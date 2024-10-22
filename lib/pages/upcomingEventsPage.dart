import 'package:flutter/material.dart';
import 'package:theft_app/mapPages/edc2024.dart';

class Upcomingeventspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: ListView(
        children: [
          EventButton(
            eventName: 'EDC 2024',
            eventDate: '2024-10-28',
            eventTime: '5:00 PM',
            onPressed: () {
              // Navigate to the map page for this event
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Edc2024()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EventButton extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final VoidCallback onPressed;

  const EventButton({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          backgroundColor: Colors.blue, // Customize your button color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$eventDate at $eventTime',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
