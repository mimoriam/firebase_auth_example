import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services:
import 'package:firebase_auth_example/services/theme.dart';
import 'package:firebase_auth_example/services/auth.dart';

// Firebase stuff:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const MyHomePage({required this.auth, required this.firestore});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Sign Out!"),
            onPressed: () async {
              final String? returnValue = await Auth(auth: widget.auth).signOut();
              if (returnValue == "Success") {}
            },
          ),
          SwitchListTile(
            onChanged: (val) {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            value: Provider.of<ThemeNotifier>(context).darkTheme,
          ),
        ],
      ),
    );
  }
}
