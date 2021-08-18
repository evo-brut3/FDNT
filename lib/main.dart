import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/login_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/news_viewmodel.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/views/root_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fdnt/features/flutter_session.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => EmailListViewModel()),
      ChangeNotifierProvider(create: (context) => AuthFirebase()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => NewsListViewModel())
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
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.black)),
      home: RootView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
