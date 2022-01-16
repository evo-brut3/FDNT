import 'dart:io';

import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/login_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/news_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/events_viewmodel.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/views/root_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fdnt/features/flutter_session.dart';
import 'package:provider/provider.dart';

// https://fluttercorner.com/certificate-verify-failed-unable-to-get-local-issuer-certificate-in-flutter/
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => EmailListViewModel()),
      ChangeNotifierProvider(create: (context) => AuthFirebase()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => NewsListViewModel()),
      ChangeNotifierProvider(create: (context) => EventsViewModel())
    ],
    child: MyApp(),
  ));

  //await MailService().getMails();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterSession().set("isLoggedToMailbox", false);
    return MaterialApp(
      title: 'FDNT',
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.black)),
      home: RootView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
