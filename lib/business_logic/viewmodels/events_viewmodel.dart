import 'package:flutter/cupertino.dart';
import 'package:fdnt/business_logic/data_types/event.dart';
import 'package:fdnt/services/fdntpl.dart';

class EventsViewModel extends ChangeNotifier {
  List<Event> events = [];

  Future<void> fetchEvents() async {
    final List<dynamic> results = await getEventsFDNT();
    if (results != null) {
      this.events = results.map((event) => Event.fromJson(event)).toList();
      notifyListeners();
    }
  }
}