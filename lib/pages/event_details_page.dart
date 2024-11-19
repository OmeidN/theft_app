import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theft_app/mapPages/map_page_parent.dart';
import 'package:theft_app/event_data.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event; // The event to display details for

  const EventDetailsPage({super.key, required this.event});

  @override
  EventDetailsPageState createState() => EventDetailsPageState();
}

class EventDetailsPageState extends State<EventDetailsPage> {
  bool _isImported = false; // Track if the event is imported by the user

  @override
  void initState() {
    super.initState();
    _checkIfEventIsImported();
  }

  // Check Firestore to see if the event has already been imported
  Future<void> _checkIfEventIsImported() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);
    final docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      final importedEvents = List<String>.from(docSnapshot['importedEvents']);
      setState(() {
        _isImported = importedEvents
            .contains(widget.event.name); // Use event name as unique ID
      });
    }
  }

  // Import the event to Firestore
  Future<void> _importEvent() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);

    // Ensure document exists, then add event to importedEvents array
    await userDocRef.set({
      'importedEvents': FieldValue.arrayUnion([widget.event.name]),
    }, SetOptions(merge: true));

    setState(() {
      _isImported = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${widget.event.name} has been imported to your upcoming events!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Event Logo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.event.logoUrl,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100);
                },
              ),
            ),
          ),
          // Event Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.event.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.event.date} at ${widget.event.time}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          // Map Preview
          Expanded(
            child: MapPageParent(
              eventName: widget.event.name,
              mapUrl: widget.event.mapUrl,
              readonly: true, // Set to true to disable interaction
            ),
          ),
          // Import Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isImported ? null : _importEvent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                backgroundColor: _isImported ? Colors.grey : Colors.blue,
              ),
              child: Text(
                _isImported ? 'Imported' : 'Import Event',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
