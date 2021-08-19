import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

  String authentication = "Bearer " + jsonDecode(loginResponse.body)['token'];

  final storage = FlutterSecureStorage();
  storage.write(key: 'authentication', value: authentication);

  return true;
}

dynamic getEventsFDNT() async {
  final Uri communityUri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_community/");

  final storage = FlutterSecureStorage();
  String authentication = await storage.read(key: 'authentication');

  final Map<String, String> communityHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };
  final communityResponse = await http.get(communityUri, headers: communityHeaders);

  final int communityInt = jsonDecode(communityResponse.body.toString())[0]['community'];
  final String community = communityInt.toString();
  final Map<String, String> eventsParameters = {
    'community': community,
    'semester': '4',
  };

  final Uri eventsUri = Uri.https("api.fdnt.pl", "/api/v1/public/events/", eventsParameters);
  final eventsResponse = await http.get(eventsUri, headers: communityHeaders);

  return jsonDecode(eventsResponse.body);
}

