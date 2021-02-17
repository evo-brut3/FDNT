import 'package:fdnt/business_logic/models/drawer_model.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:fdnt/views/root_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fdnt/views/drawer_view.dart';
import 'package:fdnt/views/login_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => DrawerModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthFirebase(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.yellow),
        home: RootView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
