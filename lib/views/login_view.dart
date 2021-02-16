import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fdnt/services/firebase_auth.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                labelText: "E-mail",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  0,
                )),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        ),
        Container(
          child: TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                labelText: "Hasło aplikacji",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  0,
                )),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        Container(
          child: ElevatedButton(
              onPressed: () {
                AuthFirebase().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim());
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Text(
                  "Zaloguj się",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        )
      ],
    );
  }
}
