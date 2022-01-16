import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  Event(this.id, this.eventName, this.from, this.to, this.background, this.forWho,
      this.description, this.mandatory, this.image);
  Event.fromJson(dynamic json) {
    debugPrint(json.toString());
    this.id = -json['id']; // Id z fdnt.pl będziemy przechowywać jako wartości ujemne.
    this.eventName = json['title'];
    this.from = DateTime.parse(json['date_start']);
    this.to = DateTime.parse(json['date_end']);
    this.mandatory = json['mandatory_event'];
    this.image = json['image'];
    this.forWho = json['community'];
    this.description = json['description'];
    if (this.mandatory) {
      this.background = Colors.red[700];
    }
    else {
      this.background = Colors.yellow[300];
    }
  }

  int id;
  String eventName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  String forWho;
  bool mandatory;
  String image;
}

class EventInfo {
  EventInfo(this.presence, this.excused, this.declaredPresence, this.declaredExcused, this.id);
  bool presence;
  bool excused;
  bool declaredPresence;
  bool declaredExcused;
  int id;
}
