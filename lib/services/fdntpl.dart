import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

String authentication;

// Zwraca true jeśli osoba ma konto w fdnt.pl oraz false w przeciwnym wypadku
Future<bool> signInFDNT(String email, String password) async {
  final Map<String, String> content = {
    'email': email,
    'password': password,
  };
  final Map<String, String> loginHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  final Uri loginUri = Uri.parse("https://api.fdnt.pl/api/account/login/");
  final loginResponse = await http.post(loginUri, body: jsonEncode(content), headers: loginHeaders);

  if (loginResponse.statusCode != 200)
    return false;

  authentication = "Bearer " + jsonDecode(loginResponse.body)['token'];
  return true;
}

// Pobiera wydarzenia z fdnt.pl
Future<List<dynamic>> getEventsFDNT() async {
  // Najpierw dowiadujemy się w jakich jest wspólnotach
  final Uri communityUri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_community/");
  final Map<String, String> communityHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };
  final communityResponse = await http.get(communityUri, headers: communityHeaders);

  if (communityResponse.statusCode != 200) {
    return null;
  }

  final dynamic decodedCommunity = jsonDecode(communityResponse.body);
  List<dynamic> eventsDecoded = [];

  // Iterujemy po wspólnotach w których jest.
  for (int i = 0; i < decodedCommunity.length; i++) {
    final int communityInt = decodedCommunity[i]['community'];
    final String community = communityInt.toString();
    final Map<String, String> eventsParameters = {
      'community': community,
      'semester': '4',
    };
    final Uri eventsUri = Uri.https("api.fdnt.pl", "/api/v1/public/events/", eventsParameters);
    final eventsResponse = await http.get(eventsUri, headers: communityHeaders);
    final List<dynamic> newEvents = jsonDecode(utf8.decode(eventsResponse.bodyBytes));

    newEvents.forEach((element) {element['community'] = decodedCommunity[i]['community_data']['name'].toString();});
    eventsDecoded.addAll(newEvents);
  }

  return eventsDecoded;
}

