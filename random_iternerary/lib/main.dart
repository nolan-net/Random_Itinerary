import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'signin.dart';
import 'createaccount.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Itinerary',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage2(),
        '/third': (context) => const createAccount(),
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
  int _selectedIndex = 0;

  String get _profileLabel => 'Profile (${widget.email})';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Itinerary'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: Text("Selected Page: ${_navBarItems[_selectedIndex].label}")),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems.asMap().entries.map((entry) {
          int index = entry.key;
          NavigationDestination destination = entry.value;

          if (index == _navBarItems.length - 1) {
            // Replace the label for the Profile tab with _profileLabel
            return NavigationDestination(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              label: _profileLabel,
            );
          } else {
            return destination;
          }
        }).toList(),
      ),
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.map_outlined),
    selectedIcon: Icon(Icons.map),
    label: 'Map',
  ),
  NavigationDestination(
    icon: Icon(Icons.bookmark_border_outlined),
    selectedIcon: Icon(Icons.bookmark_rounded),
    label: 'BookMarks',
  ),
  NavigationDestination(
    icon: Icon(Icons.format_list_bulleted),
    selectedIcon: Icon(Icons.format_list_bulleted_outlined),
    label: 'Create List',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: '', // This will be replaced by the _profileLabel in the build method
  ),
];
