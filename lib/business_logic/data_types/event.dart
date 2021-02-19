import 'dart:ui';

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.forWho);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String forWho;
}
