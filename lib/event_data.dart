// event_data.dart

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

// Centralized list of events
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
  // Add more events as needed
];
