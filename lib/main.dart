// Fixed main.dart with proper Firebase initialization and user flow handling

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/auth/views/components/user_provider.dart';
import '../../../repository/onboarding_repository.dart';
import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'repository/onboarding_repository.dart';

// Import other necessary files

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with proper error handling
    print("Initializing Firebase...");
    await Firebase.initializeApp();
    print("Firebase initialized successfully");

    // Test Firebase connection after initialization
    await checkFirebaseConnection();

    // Run the app with proper provider setup
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          // Add more providers here as needed
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
    // Run app in error mode
    runApp(FirebaseErrorApp(error: e.toString()));
  }
}

// Fixed Firebase connection check function
Future<void> checkFirebaseConnection() async {
  try {
    print('Testing Firestore connection...');

    // First, check if we can write data
    await FirebaseFirestore.instance
        .collection('app_status')
        .doc('connection_test')
        .set({
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Connected',
      'test_id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    print('Successfully wrote test data to Firestore');

    // Then try to read it back
    final testDoc = await FirebaseFirestore.instance
        .collection('app_status')
        .doc('connection_test')
        .get();

    print('Firestore read test complete:');
    print('- Document exists: ${testDoc.exists}');
    if (testDoc.exists) {
      print('- Document data: ${testDoc.data()}');
    }

    print('Firestore connection is working properly!');
  } catch (e) {
    print('Firebase connection test failed with error: $e');
    if (e is FirebaseException) {
      print('Firebase error code: ${e.code}');
      print('Firebase error message: ${e.message}');
    }
  }
}

// Fixed MyApp class with correct user flow handling
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print("Building MyApp...");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Money',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}


// Simple error app to show when Firebase fails to initialize
class FirebaseErrorApp extends StatelessWidget {
  final String error;

  const FirebaseErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Firebase Connection Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please check your internet connection and Firebase configuration.\n\nError details: $error',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
