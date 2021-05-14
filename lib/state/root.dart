import 'package:flutter/material.dart';

// Screens:
import 'package:firebase_auth_example/screens/home_page.dart';
import 'package:firebase_auth_example/screens/login_page.dart';

// Firebase stuff:
import 'package:firebase_auth_example/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Global state via provider resides here:
class RootState extends ChangeNotifier {}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);

          // If user's Id == null, go to Login Page, otherwise Home:
          if (snapshot.data?.uid == null) {
            return LoginPage(
              auth: _auth,
              firestore: _firestore,
            );
          } else {
            return MyHomePage(
              auth: _auth,
              firestore: _firestore,
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        }
      },
    );
  }
}
