// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:theft_app/mapPages/MapPageParent.dart';

class UpcomingEventsPage extends StatelessWidget {
  final List<Event> events = [
    Event(
      name: 'EDC 2024',
      date: '2024-10-28',
      time: '5:00 PM',
      logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRniXJpNK2UFfsnkP5DV1it6CaTzv32lpvSPA&s',
      mapUrl: 'https://i.redd.it/pxczjrfuuwz81.jpg',
    ),
    Event(
      name: 'Coachella 2024',
      date: '2024-04-12',
      time: '12:00 PM',
      logoUrl: 'https://play-lh.googleusercontent.com/RHwEuVQUhY-5F6cbF4iMR9rKv2tU7iAaUEk_KLF1ZDgfMc6XsuclC-A81Jz4BxlRXJU=w240-h480-rw',
      mapUrl: 'https://media.coachella.com/content/content_images/452/qsiLKM8QJB256XSDzEgTBmjXM7RqtOExeYwZz6NW.jpg',
    ),
    Event(
      name: 'Lost Lands 2023',
      date: '2024-10-28',
      time: '5:00 PM',
      logoUrl: 'https://www.lostlandsfestival.com/wp-content/uploads/2020/02/LL2020Profile.jpg',
      mapUrl: 'https://preview.redd.it/maps-are-here-v0-em31yzdd6aob1.jpg?width=1080&crop=smart&auto=webp&s=c70648e277732f40824309e465f94c2f900a043b',
    ),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Upcoming Events'),
    ),
    body: ListView(
      children: events.map((event) {
        return Column( // Use Column to add spacing
          children: [
            _createEventButton(context, event),
            const SizedBox(height: 10.0), // Space between buttons
          ],
        );
      }).toList(),
    ),
  );
}


  ElevatedButton _createEventButton(BuildContext context, Event event) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPageParent(eventName: event.name, mapUrl: event.mapUrl),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event.logoUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${event.date} at ${event.time}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class Event {
  final String name;
  final String date;
  final String time;
  final String logoUrl;
  final String mapUrl;

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.logoUrl,
    required this.mapUrl,
  });
}
