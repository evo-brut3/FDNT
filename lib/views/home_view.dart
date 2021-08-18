// It's a parent view for all views available after log in to the app.
import 'package:fdnt/features/flutter_session.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/views/about_view.dart';
import 'package:fdnt/views/calendar_view.dart';
import 'package:fdnt/views/email_tab/main_email_view.dart';
import 'package:fdnt/views/news_view.dart';
import 'package:fdnt/views/notlogged_home_view.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Center(child: NewsView(isUserLogged: true,)),
    Center(child: NotLoggedHomeView()),
    Center(child: MainEmailView()),
    Center(child: FCalendarView()),
    Center(child: AboutView())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if log out is chosen
      if (_selectedIndex == 1) {
        AuthFirebase().signOut();
        FlutterSession().set("isLoggedToMailbox", false);
      }
    });
  }

  // ignore: missing_return
  String selectedName() {
    switch (_selectedIndex) {
      case 0:
        return "Ogłoszenia";
      case 1:
        return "Wyloguj się";
      case 2:
        return "Poczta";
      case 3:
        return "Kalendarz";
      case 4:
        return "O Fundacji";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
          child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      )),
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
            icon: Icon(Icons.logout),
            label: 'Wyloguj się',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: "Poczta",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Kalendarz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "O Fundacji",
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
