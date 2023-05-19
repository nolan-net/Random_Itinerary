import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'signin.dart';
import 'createaccount.dart';
import 'map_page.dart';
import 'bookmarks.dart';
import 'profile.dart';
import 'list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Itinerary',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        //Signin.dart
        '/': (context) => const SignInPage2(),
        '/main': (context) => const MyHomePage(email: ''),
        '/create': (context) => const createAccount(),
        '/map': (context) => const MapPage(email: '{widget.email}'),
        '/bookmarks': (context) => const BookmarksPage(email:'widget.email'),
        '/list': (context) => const ListPage(email: '{widget.email}'),
        '/profile': (context) => const ProfilePage(email: '{widget.email}'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String email;

  const MyHomePage({required this.email, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
    MapPage(email:widget.email),
    BookmarksPage(email:widget.email),
    ListPage(email:widget.email),
    ProfilePage(email: widget.email),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            activeIcon: Icon(Icons.bookmarks),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
