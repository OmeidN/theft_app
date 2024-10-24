import 'package:flutter/material.dart';
import 'package:theft_app/mapPages/edc2024.dart';
import 'package:theft_app/mapPages/lostLands.dart';

class UpcomingEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: ListView(
        children: [
          Edc2024Button(),
          LostLandsButton()
        ],
      ),
    );
  }
}

// Abstract parent class for EventButton
abstract class EventButton extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String buttonImageUrl; // URL for the button image
  final Widget mapPage;

  const EventButton({
    Key? key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.buttonImageUrl,
    required this.mapPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mapPage),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          backgroundColor: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right:80),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    buttonImageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
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

class Edc2024Button extends EventButton {
  Edc2024Button()
      : super(
          eventName: 'EDC 2024',
          eventDate: '2024-10-28',
          eventTime: '5:00 PM',
          buttonImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRniXJpNK2UFfsnkP5DV1it6CaTzv32lpvSPA&s',
          mapPage: Edc2024(), // Replace with your actual map page
        );
}

class LostLandsButton extends EventButton {
  LostLandsButton()
      : super(
          eventName: 'Lost Lands 2023',
          eventDate: '2023-11-11',
          eventTime: '9:00 PM',
          buttonImageUrl: 'https://www.lostlandsfestival.com/wp-content/uploads/2020/02/LL2020Profile.jpg',
          mapPage: LostLands2023(), // Replace with your actual map page
        );
}