// State:

// Screens:

// Models:

// Services:

// Firebase stuff:
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom:

class TodoModel {
  late String todoId;
  late String content;
  late bool done;
  late Address address;

  TodoModel(
      {required this.todoId, required this.content, required this.done, required this.address});

  TodoModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    // print(documentSnapshot.data()!['address']);
    todoId = documentSnapshot.id;
    content = documentSnapshot.data()!['content'] as String;
    done = documentSnapshot.data()!['done'] as bool;
    address = Address(
        one: documentSnapshot.data()!['address']['one'] as String,
        two: documentSnapshot.data()!['address']['two'] as String);
  }
}

class Address {
  late String one;
  late String two;

  Address({
    required this.one,
    required this.two,
  });
}

/* For a JSON schema such as this:
[
{
    "content": "Hello",
    "done": false,
    "address": {
        "one": "a",
        "two": "b"
    }
}
]
 */
