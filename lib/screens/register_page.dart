import 'package:flutter/material.dart';

// Services:
import 'package:firebase_auth_example/services/auth.dart';

// Firebase stuff:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const RegisterPage({
    required this.auth,
    required this.firestore,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    key: const ValueKey("username"),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "Username"),
                    controller: _displayNameController,
                  ),
                  TextFormField(
                    key: const ValueKey("email"),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "Email"),
                    controller: _emailController,
                  ),
                  TextFormField(
                    key: const ValueKey("password"),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "Password"),
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text("Create Account"),
                    onPressed: () async {
                      final String returnValue = await Auth(auth: widget.auth).createAccount(
                        displayName: _displayNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (returnValue == "Success") {
                        _displayNameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(returnValue),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
