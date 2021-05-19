import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// State:
import 'package:firebase_auth_example/state/root.dart';

// Services:
import 'package:firebase_auth_example/state/theme.dart';

// Firebase stuff:
import 'package:firebase_core/firebase_core.dart';

// Entry point:
void main() {
  runApp(
    // Manage State/Providers here:
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => RootState()),
        ChangeNotifierProvider(create: (BuildContext context) => ThemeNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      // Configure themes here:
      theme: Provider.of<ThemeNotifier>(context).darkTheme ? darkTheme : lightTheme,

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
