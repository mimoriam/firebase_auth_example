import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  Future<String> createAccount(
      {required String displayName, required String email, required String password}) async {
    try {
      CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? user = auth.currentUser;

      var userData = {
        'name': displayName,
        'provider': 'email',
        'photoURL': user?.photoURL,
        'email': user?.email,
        'emailVerified': user?.emailVerified,
        'metadata': {
          "creationTime": user?.metadata.creationTime,
          "lastSignInTime": user?.metadata.lastSignInTime
        },
      };

      users.doc(user?.uid).get().then((doc) {
        if (doc.exists) {
          doc.reference.update(userData);
        } else {
          users.doc(user?.uid).set(userData);
        }
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
      }
      return "Error";
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  /* signIn provider returns the following data:

  User(displayName: null, email: test1@test.com, emailVerified: false, isAnonymous: false,
  metadata: UserMetadata(creationTime: 2021-05-19 19:54:42.010, lastSignInTime: 2021-05-19 19:54:42.010), phoneNumber: null, photoURL: null,
  providerData,
  [UserInfo(displayName: null, email: test1@test.com, phoneNumber: null, photoURL: null, providerId: password, uid: test1@test.com)],
  refreshToken: , tenantId: null, uid: t5m0tmuUUaZIOHsqGDRBGA6xdnZ2)

   */

  Future<String?> signIn({required String email, required String password}) async {
    try {
      CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final UserCredential authResult = userCredential;
      final User? user = authResult.user;

      var userData = {
        'name': user?.displayName,
        'provider': 'email',
        'photoURL': user?.photoURL,
        'email': user?.email,
        'emailVerified': user?.emailVerified,
        'metadata': {
          "creationTime": user?.metadata.creationTime,
          "lastSignInTime": user?.metadata.lastSignInTime
        },
      };

      users.doc(user?.uid).get().then((doc) {
        if (doc.exists) {
          doc.reference.update(userData);
        } else {
          users.doc(user?.uid).set(userData);
        }
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
      }
      return e.message;
    }
  }

/* Google Provider returns the following data:

User(displayName: Sophisticated Hum, email: mimoriam420@gmail.com, emailVerified: true, isAnonymous: false,
metadata: UserMetadata(creationTime: 2021-05-13 12:30:04.379, lastSignInTime: 2021-05-18 16:36:48.940),
phoneNumber: , photoURL: https://lh3.googleusercontent.com/a-/AOh14GhXuM1gnjfjTmiFAgRoBNRY09YcsgwWlUrnfDoq=s96-c,
providerData,
[UserInfo(displayName: Sophisticated Hum, email: mimoriam420@gmail.com, phoneNumber: , photoURL: https://lh3.googleusercontent.com/a-/AOh14GhXuM1gnjfjTmiFAgRoBNRY09YcsgwWlUrnfDoq=s96-c, providerId: google.com, uid: 106325065002315642440)],
refreshToken: , tenantId: null, uid: IbWPRZjnI6bUkJb2MarPqlZgV2R2)

 */

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    UserCredential userCredential;

    if (kIsWeb) {
      var googleProvider = GoogleAuthProvider();
      userCredential = await auth.signInWithPopup(googleProvider);
    } else {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await auth.signInWithCredential(credential);
    }

    final User? user = userCredential.user;

    var userData = {
      'name': googleUser.displayName,
      'provider': 'google',
      'photoURL': googleUser.photoUrl,
      'email': googleUser.email,
      'emailVerified': true,
      'metadata': {
        "creationTime": user?.metadata.creationTime,
        "lastSignInTime": user?.metadata.lastSignInTime
      },
    };

    users.doc(user?.uid).get().then((doc) {
      if (doc.exists) {
        doc.reference.update(userData);
      } else {
        users.doc(user?.uid).set(userData);
      }
    });

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String?> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String?> deleteAccount() async {
    if (auth.currentUser != null) {
      try {
        await FirebaseAuth.instance.currentUser!.delete();

        return "Success";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          print('The user must reauthenticate before this operation can be executed.');
        }
      }
    } else {
      return "You must be logged in first!";
    }
  }
}
