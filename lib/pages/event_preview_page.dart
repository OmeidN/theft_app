import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theft_app/event_data.dart';
import 'package:logger/logger.dart';

class EventPreviewPage extends StatefulWidget {
  final Event event;

  const EventPreviewPage({super.key, required this.event});

  @override
  EventPreviewPageState createState() => EventPreviewPageState();
}

class EventPreviewPageState extends State<EventPreviewPage> {
  bool _isImported = false;

  @override
  void initState() {
    super.initState();
    _checkIfEventIsImported();
  }

  Future<void> _checkIfEventIsImported() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);
    final docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      final importedEvents = List<String>.from(docSnapshot['importedEvents']);
      setState(() {
        _isImported = importedEvents.contains(widget.event.name);
      });
    }
  }

  Future<void> _importEvent() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    var logger = Logger();

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);

    try {
      // Ensure the event exists in Firestore
      await ensureEventExists(widget.event.name, widget.event.mapUrl);

      // Add the event to the user's imported events
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
                '${widget.event.name} has been imported to your upcoming events!'),
          ),
        );
      }
    } catch (e) {
      logger.e('Error importing event');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          Expanded(
            child: Image.network(widget.event.mapUrl),
          ),
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
