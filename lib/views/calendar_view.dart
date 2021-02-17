import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FCalendarView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          dataSource: EventsDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
        ));
  }
}

// TODO: this function should return real events
List<Event> _getDataSource() {
  var events = <Event>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  events.add(Event(
      '', startTime, endTime, const Color(0xFF0F8644), false));
  events.add(Event(
      'Conference', startTime, endTime, const Color.fromRGBO(3, 10, 1000, 2), false));
  return events;
}

class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<Event> source){
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

