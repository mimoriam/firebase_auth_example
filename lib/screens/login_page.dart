import 'package:flutter/material.dart';

// Screens:
import 'package:firebase_auth_example/screens/register_page.dart';

// Firebase stuff:
import 'package:firebase_auth_example/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom:
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const LoginPage({
    Key key,
    this.auth,
    this.firestore,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                    child: const Text("Sign In"),
                    key: const ValueKey("signIn"),
                    onPressed: () async {
                      final String returnValue = await Auth(auth: widget.auth).signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (returnValue == "Success") {
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(returnValue),
                          ),
                        );
                      }
                    },
                  ),
                  SignInButton(Buttons.GoogleDark, onPressed: () async {
                    await Auth(auth: widget.auth).signInWithGoogle();
                  }),
                  ElevatedButton(
                    child: const Text("Create Account"),
                    onPressed: () async {
                      // Navigator.pushNamed(context, '/register');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            auth: _auth,
                            firestore: _firestore,
                          ),
                        ),
                      );
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
