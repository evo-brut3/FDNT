import 'package:fdnt/business_logic/viewmodels/drawer_viewmodel.dart';
import 'package:fdnt/views/calendar_view.dart';
import 'package:fdnt/views/drawer_view.dart';
import 'package:fdnt/views/email_tab/main_email_view.dart';
import 'package:fdnt/views/login_view.dart';
import 'package:fdnt/views/email_tab/emails_list_view.dart';
import 'package:fdnt/views/news_view.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
    Center(child: NewsView()),
    Text(
      'Index 1: Communicator',
      style: optionStyle,
    ),
    Center(child: MainEmailView()),
    Center(child: FCalendarView()),
    Center(child: SignInForm())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String selectedName() {
    switch(_selectedIndex) {
      case 0:
        return "Ogłoszenia";
      case 1:
        return "Komunikator";
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
      endDrawer: DrawerView(),
      appBar: CustomAppBar(
        title: selectedName(),
        onTap : () {
          _scaffoldKey.currentState.openDrawer();
        }),
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
            icon: Icon(Icons.message),
            label: 'Komunikator',
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
      drawer: DrawerView(),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
