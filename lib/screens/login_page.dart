import 'package:flutter/material.dart';

// State:

// Screens:
import 'package:firebase_auth_example/screens/register_page.dart';

// Models:

// Services:
import 'package:firebase_auth_example/services/auth.dart';

// Firebase stuff:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom:
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const LoginPage({
    required this.auth,
    required this.firestore,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormBuilderState>();

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
              return SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormBuilderTextField(
                        name: 'email',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.email(context),
                          FormBuilderValidators.minLength(context, 6),
                        ]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle: TextStyle(),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'password',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.minLength(context, 6),
                        ]),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle: TextStyle(),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text("Sign In"),
                        onPressed: () async {
                          final String? returnValue = await Auth(auth: widget.auth).signIn(
                            email: _formKey.currentState!.fields['email']!.value,
                            password: _formKey.currentState!.fields['password']!.value,
                          );
                          if (returnValue == "Success") {
                            _formKey.currentState?.reset();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(returnValue!),
                              ),
                            );
                          }
                        },
                      ),
                      ElevatedButton(
                        child: const Text("Create Account"),
                        onPressed: () async {
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
                      SignInButton(Buttons.GoogleDark, onPressed: () async {
                        await Auth(auth: widget.auth).signInWithGoogle();
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
