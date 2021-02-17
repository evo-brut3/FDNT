import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FCalendarView extends StatefulWidget {
  @override
  _FCalendarViewState createState() => _FCalendarViewState();
}

class _FCalendarViewState extends State<FCalendarView> with SingleTickerProviderStateMixin{
  final CalendarController _calendarController = CalendarController();

  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState(){
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        allowViewNavigation: true,
        firstDayOfWeek: 1,
        controller: _calendarController,
        dataSource: EventsDataSource(_getDataSource()),
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title:"Dzień",
              iconColor :Colors.white,
              bubbleColor : Colors.blue,
              icon: Icons.today,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _calendarController.view = CalendarView.day;
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title:"Miesiąc",
              iconColor :Colors.white,
              bubbleColor : Colors.blue,
              icon:Icons.calendar_today_sharp,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _calendarController.view = CalendarView.month;
                _animationController.reverse();
              },
            ),
            //Floating action menu item
            Bubble(
              title:"Dodaj",
              iconColor :Colors.white,
              bubbleColor : Colors.blue,
              icon:Icons.add,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () {
            if(_animationController.isCompleted) {
              _animationController.reverse();
            }
            else {
              _animationController.forward();
            }
            },


          // Floating Action button Icon color
          iconColor: Colors.blue,
          // Flaoting Action button Icon
          icon: AnimatedIcons.list_view,
        )
    );
  }
}

// TODO: this function should return real events
List<Event> _getDataSource() {
  var events = <Event>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  events.add(Event('', startTime, endTime, const Color(0xFF0F8644), false));
  events.add(Event('Conference', startTime, endTime,
      const Color.fromRGBO(3, 10, 1000, 2), false));
  return events;
}

class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

