import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/upcoming_events_page.dart';
import 'pages/search_page.dart';
import 'pages/page3.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var logger = Logger();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    logger.e('Firebase failed to initialize');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Stateless MyApp, Firebase get users and setup auth

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const MainPage(); // User is logged in, show main content
          } else {
            return const LoginPage(); // User not logged in, show login page
          }
        },
      ),
    );
  }
}

// Stateful MainPage

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  // Master event list (all other classes that need it are passed this from main)

  final List<Event> events = [
    Event(
      name: 'EDC 2024',
      date: '2024-10-28',
      time: '5:00 PM',
      logoUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRniXJpNK2UFfsnkP5DV1it6CaTzv32lpvSPA&s',
      mapUrl: 'https://i.redd.it/pxczjrfuuwz81.jpg',
    ),
    Event(
      name: 'Coachella 2024',
      date: '2024-04-12',
      time: '12:00 PM',
      logoUrl:
          'https://play-lh.googleusercontent.com/RHwEuVQUhY-5F6cbF4iMR9rKv2tU7iAaUEk_KLF1ZDgfMc6XsuclC-A81Jz4BxlRXJU=w240-h480-rw',
      mapUrl:
          'https://media.coachella.com/content/content_images/452/qsiLKM8QJB256XSDzEgTBmjXM7RqtOExeYwZz6NW.jpg',
    ),
    Event(
      name: 'Lost Lands 2023',
      date: '2024-10-28',
      time: '5:00 PM',
      logoUrl:
          'https://www.lostlandsfestival.com/wp-content/uploads/2020/02/LL2020Profile.jpg',
      mapUrl:
          'https://preview.redd.it/maps-are-here-v0-em31yzdd6aob1.jpg?width=1080&crop=smart&auto=webp&s=c70648e277732f40824309e465f94c2f900a043b',
    ),
  ];

  // Pages with index selector

  @override
  void initState() {
    super.initState();
    _pages = [
      UpcomingEventsPage(events: events),
      SearchPage(events: events),
      const Page3(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Bottom Navigation Bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theft App'),
      ),
      body: _pages[_selectedIndex],
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
        onTap: _onItemTapped,
      ),
    );
  }
}
