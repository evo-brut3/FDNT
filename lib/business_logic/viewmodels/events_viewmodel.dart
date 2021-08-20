import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fdnt/business_logic/data_types/event.dart';
import 'package:fdnt/services/fdntpl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventsViewModel extends ChangeNotifier {
  List<Event> events = [];
  final storage = FlutterSecureStorage();

  Future<void> fetchEvents() async {
    List<dynamic> results;
    try {
      results = await getEventsFDNT(false);
      storage.write(key: "fdntpl_events", value: jsonEncode(results));
    }
    on SocketException {
      results = jsonDecode(await storage.read(key: "fdntpl_events"));
    }

    debugPrint(results.toString());

    if (results != null) {
      this.events = results.map((event) => Event.fromJson(event)).toList();
      notifyListeners();
    }
  }
}