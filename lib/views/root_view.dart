import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/views/home_view.dart';
import 'package:fdnt/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthFirebase authFirebase = Provider.of<AuthFirebase>(context);

    return StreamBuilder<User>(
      stream: authFirebase.onAuthChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // User is not signed in
          if (snapshot.data == null) {
            debugPrint("[User is not signed in] FirebaseUser's data is null");
            return LoginView();
          }
          // User is signed in
          debugPrint("[User is signed in]");
          return MyHomePage();
        } else {
          // User state is not yet available
          return createWaitingView();
        }
      },
    );
  }

  Widget createWaitingView() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
