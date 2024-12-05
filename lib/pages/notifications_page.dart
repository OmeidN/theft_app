import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  final Logger logger = Logger();
  final List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

Future<void> _fetchNotifications() async {
  setState(() {
    isLoading = true; // Show loading spinner
  });

  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      logger.e('User is not authenticated');
      setState(() {
        isLoading = false;
      });
      return;
    }

    logger.i('Fetching imported events for user: $userId');

    // Fetch imported events for the user
    final importsSnapshot = await FirebaseFirestore.instance
        .collection('user_imports')
        .doc(userId)
        .get();

    final List<String> importedEventNames =
        List<String>.from(importsSnapshot['importedEvents'] ?? []);

    if (importedEventNames.isEmpty) {
      logger.i('No imported events found for user: $userId');
      setState(() {
        notifications.clear();
        isLoading = false;
      });
      return;
    }

    logger.i('User has imported events: $importedEventNames');

    // Fetch notifications for the imported events
    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('notifications')
        .where('eventName', whereIn: importedEventNames) // Query by eventName
        .orderBy('timestamp', descending: true)
        .get();

    final List<Map<String, dynamic>> fetchedNotifications =
        querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'eventName': data['eventName'] ?? 'Unknown Event',
        'message': data['message'] ?? 'No message provided',
        'timestamp': data['timestamp']?.toDate() ?? DateTime.now(),
        'userId': data['userId'] ?? 'Unknown',
      };
    }).toList();

    setState(() {
      notifications.clear();
      notifications.addAll(fetchedNotifications);
      isLoading = false;
    });

    logger.i('Fetched ${notifications.length} notifications.');
  } catch (e) {
    logger.e('Error fetching notifications: $e');
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text('No notifications available.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification['message']),
                      subtitle: Text(
                          '${notification['eventName']} • ${notification['timestamp']}'),
                    );
                  },
                ),
    );
  }
}
