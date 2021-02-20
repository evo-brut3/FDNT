import 'package:fdnt/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_session/flutter_session.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String email;
  String password;

  Future<void> signIn({email, password}) async {
    await AuthFirebase().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );
    this.email = email;
    this.password = password;
    await FlutterSession().set("email", this.email);
  }
}
