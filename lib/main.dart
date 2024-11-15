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
import 'package:theft_app/event_data.dart';


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


  // Pages with index selector

@override
void initState() {
  super.initState();
  _pages = [
    const UpcomingEventsPage(), // Remove the events parameter here
    SearchPage(events: events), // Keep this as it is
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
