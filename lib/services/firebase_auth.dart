import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

class AuthFirebase extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthFirebase();

  Future<String> get userEmail async {
    return _firebaseAuth.currentUser.email;
  }

  Future<String> get userName async {
    var email = await userEmail
      ..toString();

    return email.substring(0, email.indexOf("@")).replaceAll(".", "");
  }

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint("[AuthFirebase] No user found for that email");
      } else if (e.code == 'wrong-password') {
        debugPrint("[AuthFirebase] Wrong password provided for that user");
      } else {
        debugPrint("[AuthFirebase] Other exception $e");
      }
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Stream<User> get onAuthChanges => _firebaseAuth.idTokenChanges();
}
