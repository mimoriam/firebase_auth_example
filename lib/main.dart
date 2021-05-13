import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens:
import 'package:firebase_auth_example/state/root.dart';
import 'package:firebase_auth_example/screens/home_page.dart';
import 'package:firebase_auth_example/screens/login_page.dart';
import 'package:firebase_auth_example/screens/register_page.dart';

// Firebase stuff:
import 'package:firebase_core/firebase_core.dart';

// Entry point:
void main() {
  runApp(
    // Manage State/Providers here:
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => RootState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      // Configure themes here:
      theme: ThemeData.dark(),

      // Configure routes/pages here:
      routes: {
        '/root': (context) => Root(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage()
      },

      home: FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Root();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        },
      ),
    );
  }
}
