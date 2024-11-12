import 'package:flutter/material.dart';
import 'package:theft_app/mapPages/MapPageParent.dart';

class UpcomingEventsPage extends StatelessWidget {
  final List<Event> events;

  UpcomingEventsPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: events.map((event) {
              return Column(
                children: [
                  _createEventButton(context, event),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  ElevatedButton _createEventButton(BuildContext context, Event event) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MapPageParent(eventName: event.name, mapUrl: event.mapUrl),
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
              Text(event.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${event.date} at ${event.time}',
                  style: const TextStyle(fontSize: 16)),
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
