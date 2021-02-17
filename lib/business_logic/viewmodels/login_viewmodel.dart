import 'package:fdnt/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn({email, password}) async {
    await AuthFirebase().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }
}
