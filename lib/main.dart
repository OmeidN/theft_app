import 'package:flutter/material.dart';
import 'pages/upcomingEventsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: UpcomingEventsPage(), // Change this to UpcomingEventsPage
    );
  }
}
