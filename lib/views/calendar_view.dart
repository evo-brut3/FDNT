import 'package:fdnt/business_logic/viewmodels/events_viewmodel.dart';
import 'package:fdnt/services/fdntpl.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fdnt/business_logic/data_types/event.dart';



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
    Provider.of<EventsViewModel>(context, listen: false).fetchEvents();

    return Scaffold(
        appBar: CustomAppBar(
          title: "Kalendarz",
        ),
      body: Consumer<EventsViewModel>(builder: (context, model, child) {
        return SfCalendar(
          view: CalendarView.month,
          allowViewNavigation: true,
          firstDayOfWeek: 1,
          controller: _calendarController,
          dataSource: EventsDataSource(model.events),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          onTap: (CalendarTapDetails details) {
            // Show an event when which was tapped
            if(details.appointments != null &&  details.appointments.length >= 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => EventShow(details.appointments.first)),
              );
              _calendarController.view = CalendarView.month;
            }
          },
        );}),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
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
          animatedIconData: AnimatedIcons.list_view,
        )
    );
  }
}

// An event showing
class _EventShowState extends State<EventShow> {
  final TextStyle textStyle = TextStyle(
      fontSize: 20,
      color: Colors.black,
      );

  final EdgeInsets globalInsets = EdgeInsets.symmetric(horizontal: 15, vertical: 13);
  final EdgeInsets horizontalInsets = EdgeInsets.symmetric(horizontal: 15, vertical: 1);
  final EdgeInsets textInsets = EdgeInsets.symmetric(horizontal: 15);
  final dateFormat = new DateFormat('yyyy-MM-dd hh:mm');

  RichText presenceInfoText(bool yes, String pref) {
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: <TextSpan>[
          TextSpan(text: pref),
          yes ? TextSpan(text: "tak", style: TextStyle(color: Colors.green))
              : TextSpan(text: "nie", style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getEventInfo(-widget.event.id, false);

    final messageController = TextEditingController();

    return new Scaffold(
      body: ListView(
        children: [
          Container(
            margin: globalInsets,
            alignment: Alignment.centerLeft,
            child: BackButton()
          ),
          Container(
            margin: globalInsets,
            child: Row(
            children: [
              Icon(Icons.circle, color: widget.event.background),
              Flexible(
                  child: Container( margin: textInsets,
                  child: Text(widget.event.eventName,
                    style: textStyle, overflow: TextOverflow.clip, maxLines: 3,))
              )
            ],
          )),
          Container(
              margin: globalInsets,
              child: Row(
                children: [
                  Icon(Icons.description),
                  Flexible(
                      child: Container( margin: textInsets,
                          child: Text(widget.event.description,
                            style: textStyle, overflow: TextOverflow.ellipsis, maxLines: 100,))
                  )
                ],
              )),
          Container(
              margin: globalInsets,
              child: Row(
                children: [
                  Icon(Icons.event),
                  Flexible(
                      child: Container( margin: textInsets,
                          child: Text(widget.event.forWho,
                            style: textStyle, overflow: TextOverflow.ellipsis,))
                  )
                ],
              )),
          Container(
              margin: globalInsets,
              child: Row(
                children: [
                  Icon(Icons.access_time),
                  Flexible(
                      child: Container( margin: textInsets,
                          child: Text(dateFormat.format(widget.event.from),
                            style: textStyle, overflow: TextOverflow.ellipsis,))
                  )
                ],
              )),
          Container(
              margin: globalInsets,
              child: Row(
                children: [
                  Icon(null),
                  Flexible(
                      child: Container( margin: textInsets,
                          child: Text(dateFormat.format(widget.event.to),
                            style: textStyle, overflow: TextOverflow.ellipsis,))
                  )
                ],
              )),
          Container(
              margin: globalInsets,
              child: Row(
                children: [
                  Icon(Icons.assignment_turned_in_sharp),
                  Flexible(
                      child: Container( margin: textInsets,
                          child: Text(widget.event.mandatory ? "Obowiązkowe" : "Nieobowiązkowe",
                            style: textStyle, overflow: TextOverflow.ellipsis,))
                  )
                ],
              )),
          widget.event.id < 0 ?
            (!widget.presenceManage ?
              Container(
                margin: globalInsets,
                child: ElevatedButton(
                  onPressed: () async {
                      widget.info = await getEventInfo(-widget.event.id, false);
                      setState(() {
                        widget.presenceManage = true;
                      });
                    },
                  child: Text('Zarządzaj obecnością'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                )
              )
            :
                Column (
                  children: [
                        Container(
                            padding: horizontalInsets,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await declare(!widget.info.declaredPresence, widget.info.declaredExcused,
                                                -widget.event.id, false);
                                widget.info = await getEventInfo(-widget.event.id, false);
                                setState(() {});
                              },
                              child: widget.info.declaredPresence ?
                                Text('Zadeklaruj obecność') : Text('Zadeklaruj nieobecność'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                            )
                        ),
                        Container(
                            padding: horizontalInsets,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await declare(widget.info.declaredPresence, !widget.info.declaredExcused,
                                  -widget.event.id, false);
                                widget.info = await getEventInfo(-widget.event.id, false);
                                setState(() {});
                              },
                              child: widget.info.declaredExcused ?
                                Text('Zadeklaruj usprawiedliwienie') : Text('Wycofaj usprawiedliwienie'),
                                style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                            )
                        ),
                    Padding(
                        padding: globalInsets
                    ),
                    presenceInfoText(widget.info.presence, "Obecność: "),
                    presenceInfoText(widget.info.excused, "Usprawiedliwiona: "),
                    Padding(
                        padding: globalInsets
                    ),
                    Padding(
                      padding: horizontalInsets,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                          labelText: "Wiadomość do starosty...",
                        )
                      ),
                    ),
                    Container(
                        padding: globalInsets,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool ok = await sendMessage(widget.info.id, messageController.value.text);
                            if (ok) {
                              showToast("Wiadomość wysłana!", context);
                              messageController.text = "";
                            }
                            else {
                              showToast("Błąd przy wysyłaniu wiadommości.", context);
                            }
                          },
                          child:Text("Wyślij wiadomość"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                        )
                    ),
                    Padding(
                        padding: globalInsets
                    ),
                  ],
                )
            ): SizedBox()
        ],
      )
    );
  }
}

class EventShow extends StatefulWidget {
  EventShow(this.event, {Key key}) : super(key: key);

  final Event event;
  EventInfo info;
  bool presenceManage = false;


  @override
  _EventShowState createState() => _EventShowState();
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
}

void showToast(String text, BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}


