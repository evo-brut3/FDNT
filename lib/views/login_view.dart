import 'package:fdnt/business_logic/viewmodels/drawer_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/login_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);

    return Column(
      children: [
        Container(
          child: TextFormField(
            controller: loginViewModel.emailController,
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
            controller: loginViewModel.passwordController,
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
              await loginViewModel.signIn(
                  email: loginViewModel.emailController.text.trim(),
                  password: loginViewModel.passwordController.text.trim());

              await Provider.of<DrawerViewModel>(context, listen: false)
                  .fetchTabs();
              await Provider.of<EmailListViewModel>(context, listen: false)
                  .fetchEmails(loginViewModel.email, loginViewModel.password);
            },
            color: Colors.yellow,
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        )],
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
