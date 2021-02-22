import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Future<bool> signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Niestety, ten użytkownik nie jest jeszcze w naszej bazie"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Niepoprawne hasło"),
        ));
      } else {
        debugPrint(e.code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Coś poszło nie tak..."),
        ));
      }
      return false;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Stream<User> get onAuthChanges => _firebaseAuth.idTokenChanges();
}
