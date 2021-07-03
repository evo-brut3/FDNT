import 'package:fdnt/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fdnt/features/flutter_session.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String email;
  String password;

  Future<bool> signIn(BuildContext context) async {
    bool ok = await AuthFirebase().signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
        context
    );

    if (ok) {
      this.email = emailController.text.trim();
      this.password = passwordController.text.trim();
      await FlutterSession().set("email", this.email);
    }
    return ok;
  }
}
