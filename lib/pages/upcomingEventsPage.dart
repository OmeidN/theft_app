import 'package:flutter/material.dart';
import 'package:theft_app/mapPages/edc2024.dart';
import 'package:theft_app/mapPages/Coachella2024.dart';

class UpcomingEventsPage extends StatelessWidget {
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
            logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRniXJpNK2UFfsnkP5DV1it6CaTzv32lpvSPA&s', // EDC logo
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Edc2024()),
              );
            },
          ),
          EventButton(
            eventName: 'Coachella 2024',
            eventDate: '2024-04-12',
            eventTime: '12:00 PM',
            logoUrl: 'https://play-lh.googleusercontent.com/RHwEuVQUhY-5F6cbF4iMR9rKv2tU7iAaUEk_KLF1ZDgfMc6XsuclC-A81Jz4BxlRXJU=w240-h480-rw', // Coachella logo
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Coachella2024()),
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
  final String logoUrl; // Add a parameter for the logo URL
  final VoidCallback onPressed;

  const EventButton({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.logoUrl, // Include logoUrl in constructor
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
          backgroundColor: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 80),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    logoUrl, // Use the logo URL passed from the parent widget
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error); // Fallback if image fails to load
                    },
                  ),
                ),
              ),
              Column(
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
            ],
          ),
        ),
      ),
    );
  }
}
