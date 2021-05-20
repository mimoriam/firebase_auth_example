// State:

// Screens:

// Models:
import 'package:firebase_auth_example/models/todo.dart';

// Services:

// Firebase stuff:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Custom:

class Database {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Database({required this.auth, required this.firestore});

  Stream<List<TodoModel>> streamTodos() {
    try {
      return firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("todos")
          // .where("done", isEqualTo: false)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> query) {
        final List<TodoModel> returnValue = <TodoModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in query.docs) {
          returnValue.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return returnValue;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo({required String content}) async {
    try {
      firestore.collection("users").doc(auth.currentUser!.uid).collection("todos").add({
        "content": content,
        "done": false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String todoId}) async {
    try {
      firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("todos")
          .doc(todoId)
          .update({"done": true});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo({required String todoId}) async {
    try {
      firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("todos")
          .doc(todoId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
