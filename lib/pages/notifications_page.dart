import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

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
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      logger.e('User is not authenticated');
      return;
    }

    logger.i('Fetching imported events for user: $userId');

    // Fetch imported events
    final importsSnapshot = await FirebaseFirestore.instance
        .collection('user_imports')
        .doc(userId)
        .get();

    final List<String> importedEvents = List<String>.from(
      importsSnapshot.data()?['importedEvents'] ?? [],
    );

    logger.i('User has imported events: $importedEvents');

    final List<Map<String, dynamic>> fetchedNotifications = [];

    for (String eventId in importedEvents) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('notifications')
          .get();

      fetchedNotifications.addAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['timestamp'] = (data['timestamp'] as Timestamp).toDate();
          return data;
        }),
      );
    }

    // Sort notifications globally by timestamp in descending order
    fetchedNotifications.sort((a, b) {
      final timestampA = a['timestamp'] as DateTime;
      final timestampB = b['timestamp'] as DateTime;
      return timestampB.compareTo(timestampA);
    });

    setState(() {
      notifications.clear();
      notifications.addAll(fetchedNotifications);
    });

    logger.i('Fetched ${notifications.length} notifications.');
  } catch (e) {
    logger.e('Error fetching notifications: $e');
  }
  setState(() {
    isLoading = false; // Stop spinner
  });
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
                    IconData notificationIcon = Icons.warning_rounded;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 212, 78, 37),
                        child: Icon(notificationIcon, color: Colors.white),
                      ),
                      title: Text(notification['message']),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${DateFormat.yMMMd().format(notification['timestamp'])} • ',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: DateFormat.Hm().format(notification['timestamp']),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
