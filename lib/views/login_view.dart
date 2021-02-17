import 'package:fdnt/business_logic/models/drawer_model.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions;

  void initState() {
    _widgetOptions = <Widget>[
      Text('Index 1: Home'),
      SignInForm(),
      Text('Index 3: Info'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FDNT"),
      ),
      body: Center(
          child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      )),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber[800],
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final drawerModel = DrawerModel();

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
          child: ProgressButton(
            borderRadius: 8.0,
            defaultWidget: Text("Zaloguj się"),
            animate: true,
            progressWidget: CircularProgressIndicator(),
            onPressed: () async {
              await AuthFirebase().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim());

              Provider.of<DrawerModel>(context, listen: false)
                  .addAll(await FirebaseService().getTabs());
            },
            color: Colors.yellow,
          ),
          // child: ElevatedButton(
          //     onPressed: () {
          //       AuthFirebase().signIn(
          //           email: emailController.text.trim(),
          //           password: passwordController.text.trim()).whenComplete(() => );
          //     },
          //     child: Container(
          //       alignment: Alignment.center,
          //       padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          //       child: Text(
          //         "Zaloguj się",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     )
          //   ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        ),
        Container(
          child: ElevatedButton(
              onPressed: () {
                AuthFirebase().signOut();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Text(
                  "Wyloguj się",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        )
      ],
    );
  }
}

Future<void> connectToFirebase() async {}

Widget createWaitingView() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ),
  );
}
