// It's a parent view for all views available after log in to the app.
import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:fdnt/features/flutter_session.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/views/about_view.dart';
import 'package:fdnt/views/calendar_view.dart';
import 'package:fdnt/views/email_tab/main_email_view.dart';
import 'package:fdnt/views/news_view.dart';
import 'package:fdnt/views/notlogged_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(child: NewsView(isUserLogged: true,)),
    Center(child: MainEmailView()),
    Center(child: FCalendarView()),
    Center(child: AboutView()),
    Center(child: NotLoggedHomeView())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if log out is chosen
      if (_selectedIndex == 4) {
        AuthFirebase().signOut();
        FlutterSession().set("isLoggedToMailbox", false);
        final storage = FlutterSecureStorage();

        storage.delete(key: CacheKey.mailboxLogin);
        storage.delete(key: CacheKey.mailboxPassword);
      }
    });
  }

  // ignore: missing_return
  String selectedName() {
    switch (_selectedIndex) {
      case 0:
        return "Ogłoszenia";
      case 1:
        return "Poczta";
      case 2:
        return "Kalendarz";
      case 3:
        return "O Fundacji";
      case 4:
        return "Wyloguj się";
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
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Wyloguj się',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
