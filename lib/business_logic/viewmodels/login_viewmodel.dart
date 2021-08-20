import 'package:fdnt/services/fdntpl.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fdnt/features/flutter_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final storage = FlutterSecureStorage();
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

    storage.write(key: "email", value: emailController.text.trim());
    storage.write(key: "password", value: passwordController.text.trim());

    await signInFDNT(emailController.text.trim(), passwordController.text.trim())
        .then((value) => {
          if (value) {
            FirebaseService().addFdntplUser(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
          } else {
            debugPrint("User doesn't exists on fdnt.pl platform")
          }
    });

    if (ok) {
      this.email = emailController.text.trim();
      this.password = passwordController.text.trim();
      await FlutterSession().set("email", this.email);
    }
    return ok;
  }
}
