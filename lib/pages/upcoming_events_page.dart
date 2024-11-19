import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theft_app/event_data.dart'; // Import the global events list
import 'package:theft_app/mapPages/map_page_parent.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  UpcomingEventsPageState createState() => UpcomingEventsPageState();
}

class UpcomingEventsPageState extends State<UpcomingEventsPage> {
  List<Event> importedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadImportedEvents();
  }

  // Load imported events from Firestore for the current user
  Future<void> _loadImportedEvents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);
    final docSnapshot = await userDocRef.get();

    if (docSnapshot.exists) {
      final eventNames = List<String>.from(docSnapshot['importedEvents']);
      setState(() {
        importedEvents = eventNames
            .map((name) => events
                .firstWhere((e) => e.name == name)) // Use global 'events' list
            .toList();
      });
    }
  }

  // Remove an event from the imported list
  Future<void> _removeEvent(Event event) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('user_imports').doc(userId);
    await userDocRef.update({
      'importedEvents': FieldValue.arrayRemove([event.name]),
    });

    setState(() {
      importedEvents.remove(event);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${event.name} has been removed from your upcoming events.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: importedEvents.isEmpty
          ? const Center(child: Text("No events imported yet."))
          : ListView.builder(
              itemCount: importedEvents.length,
              itemBuilder: (context, index) {
                final event = importedEvents[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text('${event.date} at ${event.time}'),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      event.logoUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeEvent(event),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPageParent(
                          eventName: event.name,
                          mapUrl: event.mapUrl,
                          readonly: false,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
