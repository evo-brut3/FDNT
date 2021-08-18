import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

String authentication;

Future<void> signInFDNT(String email, String password) async {
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

  authentication = "Bearer " + jsonDecode(loginResponse.body)['token'];
}

dynamic getEventsFDNT() async {
  final Uri communityUri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_community/");
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

