import 'package:flutter/material.dart';
import 'pages/page2.dart';
import 'pages/upcomingEventsPage.dart'; // Correct import with the right class name
import 'pages/page3.dart';
import 'pages/page4.dart';

void main() { 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: UpcomingEventsHome(), // Use the main page that includes navigation
    );
  }
}

class UpcomingEventsHome extends StatefulWidget {
  @override
  _UpcomingEventsHomeState createState() => _UpcomingEventsHomeState();
}

class _UpcomingEventsHomeState extends State<UpcomingEventsHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UpcomingEventsPage(), // Main events page
    Page2(),
    Page3(),
    Page4(),
  ];

void _onItemTapped(int index) {
  print('Tapped index: $index'); // Debugging line
  setState(() {
    _selectedIndex = index; // Update the selected index
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theft App'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped, // Handle item taps
      ),
    );
  }
}
