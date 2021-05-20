import 'package:flutter/material.dart';

// State:
import 'package:provider/provider.dart';
import 'package:firebase_auth_example/state/theme.dart';

// Screens:

// Models:
import 'package:firebase_auth_example/models/todo.dart';

// Services:
import 'package:firebase_auth_example/services/auth.dart';
import 'package:firebase_auth_example/services/database.dart';

// Firebase stuff:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom:

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
          ElevatedButton(
            onPressed: () {
              Database(auth: widget.auth, firestore: widget.firestore)
                  .addTodo(content: "Hello World Test 3");
            },
            child: Text("Add"),
          ),
          Expanded(
            child: StreamBuilder<List<TodoModel>>(
              stream: Database(auth: widget.auth, firestore: widget.firestore).streamTodos(),
              builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("You don't have any unfinished Todos"),
                    );
                  }
                }
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].content),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          Database(auth: widget.auth, firestore: widget.firestore)
                              .deleteTodo(todoId: snapshot.data![index].todoId);
                        },
                        child: Text("Delete"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
