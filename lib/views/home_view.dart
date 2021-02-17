import 'package:fdnt/views/calendar_view.dart';
import 'package:fdnt/views/drawer_view.dart';
import 'package:fdnt/views/login_view.dart';
import 'package:fdnt/views/mail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Column(
        children: [SignInForm()],
      ),
    ),
    Text(
      'Index 1: Communicator',
      style: optionStyle,
    ),
    Center(child : MailView()),
    Center(child: FCalendarView()),
    Text(
      'Index 4: Info',
      style: optionStyle,
    ),
  ];

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
