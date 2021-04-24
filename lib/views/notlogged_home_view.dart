// This view is parent for views available, when user is not logged in to app

import 'package:fdnt/business_logic/viewmodels/drawer_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/login_viewmodel.dart';
import 'package:fdnt/views/drawer_view.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'about_view.dart';
import 'news_view.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NotLoggedHomeView extends StatefulWidget {
  NotLoggedHomeView({Key key}) : super(key: key);

  @override
  _NotLoggedHomeViewState createState() => _NotLoggedHomeViewState();
}

class _NotLoggedHomeViewState extends State<NotLoggedHomeView> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [
      Center(child: NewsView(isUserLogged: false)),
      SignInForm(),
      AboutView(),
    ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellow[600],
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        selectedFontSize: 8,
        unselectedFontSize: 8,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Główna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "Zaloguj się",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "O Fundacji",
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Logowanie",
      ),
      body: Column(
        children: [
          Container(
            child: TextFormField(
              controller: loginViewModel.emailController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  labelText: "E-mail",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0,)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          ),
          Container(
            child: TextFormField(
              controller: loginViewModel.passwordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  labelText: "Hasło aplikacji",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0,)),
              obscureText: true,
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          ),
          Container(
            child: ElevatedButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 41,
                alignment: Alignment.center,
                child: Text("Zaloguj się", textAlign: TextAlign.center,),
              ),
              onPressed: () async {
                showDialog(
                    barrierDismissible: false,
                    context: _scaffoldKey.currentContext,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator());
                    });
                bool ok = await loginViewModel.signIn(context);
                Navigator.of(_scaffoldKey.currentContext).pop();

                if(ok) {
                  await Provider.of<DrawerViewModel>(context, listen: false)
                      .fetchTabs();
                }
              },
              //  color: Colors.yellow,
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          ),
          TextButton(
              onPressed: () {
                String email = loginViewModel.emailController.text.trim();
                Widget cancelButton = TextButton(
                  child: Text("Anuluj"),
                  onPressed:  () {
                    Navigator.of(context).pop();
                  },
                );
                Widget continueButton = TextButton(
                  child: Text("Wyślij"),
                  onPressed:  () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                    Navigator.of(context).pop();
                  },
                );

                AlertDialog alert = AlertDialog(
                  title: Text("Zmiana hasła"),
                  content: email != null && email.contains("@") ?
                  Text("Czy wysłać na adres " + email + " link do zmiany/ustawienia hasła?") :
                  Text("Najpierw wpisz swój adres email w pole tekstowe."),
                  actions: [
                    cancelButton,
                    email != null && email.contains("@") ? continueButton : null
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              child: Text("Nie znasz hasła?", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16))
          )],
      ),
    );
  }
}
