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
    _fetchNotifications(); // Fetch notifications on page load
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

      logger.i('Fetching notifications for user: $userId');

      // Fetch the user's imported events
      final importsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_imports')
          .get();

      final List<String> importedEventIds =
          importsSnapshot.docs.map((doc) => doc.id).toList();

      if (importedEventIds.isEmpty) {
        logger.i('No imported events found for user: $userId');
        setState(() {
          notifications.clear();
          isLoading = false;
        });
        return;
      }

      logger.i('User has imported events: $importedEventIds');

      // Fetch notifications for the imported events
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('notifications')
          .where(FieldPath.documentId, whereIn: importedEventIds)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> fetchedNotifications =
          querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'eventName': doc.reference.parent.parent!.id,
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
    } catch (e, stackTrace) {
      logger.e('Error fetching notifications: $e');
      logger.e(stackTrace.toString());
      setState(() {
        isLoading = false; // Stop loading spinner
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchNotifications, // Refresh notifications manually
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child:
                                Icon(Icons.notifications, color: Colors.white),
                          ),
                          title: Text(
                            notification['message'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${_formatTimestamp(notification['timestamp'])} • ${notification['eventName']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
