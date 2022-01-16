import 'dart:convert';
import 'dart:io';

import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:fdnt/business_logic/data_types/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final client = http.Client();

// Zwraca true jeśli osoba ma konto w fdnt.pl oraz false w przeciwnym wypadku
Future<bool> signInFDNT(String email, String password) async {

  final Map<String, String> content = {
    'username': email,
    'password': password,
  };
  final Map<String, String> loginHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  final Uri loginUri = Uri.parse("https://api.fdnt.pl/api/account/login/");
  final loginResponse = await client.post(loginUri, body: jsonEncode(content), headers: loginHeaders);

  if (loginResponse.statusCode != 200)
    return false;

  String authentication = "Bearer " + jsonDecode(loginResponse.body)['token'];
  // W fdnt.pl użytkownicy mają jakieś swoje id
  int fdntUserId = jsonDecode(loginResponse.body)['user']['pk'];


  final storage = FlutterSecureStorage();
  storage.write(key: 'authentication', value: authentication);
  storage.write(key: 'id', value: fdntUserId.toString());

  return true;
}

Future<void> repeatSignIn() async {
  final storage = FlutterSecureStorage();
  String email = await storage.read(key: CacheKey.mailboxLogin);
  String password = await storage.read(key: CacheKey.appPassword);

  debugPrint("authentication repeated");
  await signInFDNT(email, password);
}

int getSemester() {
  return (DateTime.now().year - 2019) * 2 + 1;
}

// Pobiera wydarzenia z fdnt.pl
// Wywołując z zewnątrz ustaw repeat = false
Future<List<dynamic>> getEventsFDNT(bool repeat) async {
  // Najpierw dowiadujemy się w jakich jest wspólnotach
  final Uri communityUri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_community/");

  final storage = FlutterSecureStorage();
  String authentication = await storage.read(key: 'authentication');

  final Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };
  final communityResponse = await client.get(communityUri, headers: headers);

  if (communityResponse.statusCode != 200) {
    debugPrint(communityResponse.reasonPhrase + " community " + authentication);
    if (repeat) {
      throw SocketException(null);
    }
    else {
      await repeatSignIn();
      return getEventsFDNT(true);
    }
  }

  final dynamic decodedCommunity = jsonDecode(communityResponse.body);
  List<dynamic> eventsDecoded = [];
  final int communityInt = decodedCommunity[0]['community'];
  final String community = communityInt.toString();

  storage.write(key: "community", value: community);

  final Map<String, String> teamParameters = {
    'community': community,
    'active': "1"
  };
  final Uri teamUri = Uri.https(
      "api.fdnt.pl", "/api/v1/public/user_team/", teamParameters);
  final teamResponse = await client.get(
      teamUri, headers: headers);
  if (teamResponse.statusCode != 200) {
    debugPrint(teamResponse.reasonPhrase + " team " + community);
    throw SocketException(null);
  }
  else{
    final List<dynamic> teamInfo = jsonDecode(
        utf8.decode(teamResponse.bodyBytes));
    int team = teamInfo[0]['team']['id'];
    storage.write(key: 'team', value: team.toString());
  }


  // Iterujemy po ostatnich semestrach.
    for (int j = getSemester(); j >= getSemester()-2; j--) {

      final Map<String, String> eventsParameters = {
        'community': community,
        'semester': j.toString(),
      };
      final Uri eventsUri = Uri.https(
          "api.fdnt.pl", "/api/v1/public/events/", eventsParameters);
      final eventsResponse = await client.get(
          eventsUri, headers: headers);
      if (eventsResponse.statusCode != 200) {
        debugPrint(eventsResponse.reasonPhrase + " events " + community);
        //throw SocketException(null);
      }
      else {
        final List<dynamic> newEvents = jsonDecode(
            utf8.decode(eventsResponse.bodyBytes));

        newEvents.forEach((element) {
          element['community'] =
              decodedCommunity[0]['community_data']['name'].toString();
        });
        eventsDecoded.addAll(newEvents);
      }
    }

  return eventsDecoded;
}

// Informacje o obecności na wydarzeniu
// Pobiera wydarzenia z fdnt.pl
// Wywołując z zewnątrz ustaw repeat = false
Future<EventInfo> getEventInfo(int eventId, bool repeat) async {
  final Uri communityUri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_events/fetch_user_event/");

  final storage = FlutterSecureStorage();
  String authentication = await storage.read(key: 'authentication');
  String fdntUserId = await storage.read(key: 'id');
  String team = await storage.read(key: 'team');

  final Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };

  final body = jsonEncode({"event": eventId.toString(), "team": int.parse(team), "user": fdntUserId});
  debugPrint(body.toString());


  final response = await client.post(communityUri, headers: headers, body: body);
  if (response.statusCode != 200) {
    if (repeat) {
      debugPrint(response.reasonPhrase + "events" + body);
      return EventInfo(false, false, false, false, 0);
    }
    else {
      await repeatSignIn();
      return getEventInfo(eventId, true);
    }
  }

  debugPrint(response.body);

  final dynamic decodedInfo = jsonDecode(utf8.decode(response.bodyBytes));

  return EventInfo(decodedInfo['presence'], decodedInfo['excused_absence'],
          decodedInfo['declared_presence'], decodedInfo['declared_excused_absence'],
          decodedInfo['id']);
}

Future<bool> declare(bool presence, bool excused, int eventId, bool repeat) async {
  final storage = FlutterSecureStorage();

  String authentication = await storage.read(key: 'authentication');
  String team = await storage.read(key: 'team');

  final Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };

  final Uri uri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_events/change_declared_presence_and_absence/");

  final body = jsonEncode({"event": eventId, "team": int.parse(team),
                "declared_presence": presence, "declared_excused_absence": excused});

  final response = await client.post(uri, headers: headers, body: body);

  if (response.statusCode == 200) {
    return true;
  }
  else {
    if (repeat) {
      return false;
    }
    else {
      await repeatSignIn();
      return declare(presence, excused, eventId, true);
    }
  }
}

// Wysyła wiadomosć. Zwaraca true w przypadku powodzenia
// oraz false w przeciwnym wypadku.
Future<bool> sendMessage(int eventInfoId, String message) async {
  final storage = FlutterSecureStorage();

  String authentication = await storage.read(key: 'authentication');

  final Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': authentication,
  };

  final Uri uri = Uri.parse("https://api.fdnt.pl/api/v1/public/user_events/" +
      eventInfoId.toString() + "/add_new_message/");

  final body = jsonEncode({"reply": message});

  final response = await client.post(uri, headers: headers, body: body);
  if (response.statusCode == 200) {
    return true;
  }
  else {
    return false;
  }
}

