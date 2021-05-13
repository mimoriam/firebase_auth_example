import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase stuff:
import 'package:firebase_auth_example/state/root.dart';
import 'package:firebase_auth_example/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const MyHomePage({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final rootStateModel = context.watch<RootState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ElevatedButton(
        child: Text("Sign Out!"),
        onPressed: () async {
          final String returnValue = await Auth(auth: widget.auth).signOut();
          if (returnValue == "Success") {}
        },
      ),
    );
  }
}
