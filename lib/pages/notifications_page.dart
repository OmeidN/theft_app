import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'eventName': 'EDC 2024',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'userId': 'user123',
    },
    {
      'eventName': 'Coachella 2024',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'userId': 'user456',
    },
    {
      'eventName': 'Lost Lands 2023',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'userId': 'user789',
    },
  ];

  NotificationsPage({super.key});

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
      ),
      body: notifications.isEmpty
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.pin_drop, color: Colors.white),
                      ),
                      title: Text(
                        'New pin added for ${notification['eventName']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${_formatTimestamp(notification['timestamp'])} by User: ${notification['userId']}',
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
