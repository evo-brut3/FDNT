import 'dart:ui';
import 'package:enough_mail/media_type.dart';
import 'package:fdnt/business_logic/viewmodels/drawer_viewmodel.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:provider/provider.dart';

Widget drawerView({@required BuildContext context, Widget items}) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  children: [
                    Text("Zalogowano:", textAlign: TextAlign.start,),
                    Text(FirebaseAuth.instance.currentUser.email, style: TextStyle(color: Colors.blue),),
                    Container(
                        height: 80,
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                            onTap: () {
                              AuthFirebase().signOut();
                              FlutterSession().set("isLoggedToMailbox", false);
                            },
                            child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  Text("Wyloguj się", style: TextStyle(fontSize: 16),)
                                ]))
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(color: Colors.yellow[200]),
            ),
            items != null
                ? items
                : Container()
          ],
        ),
      ));
}

 /* Widget createListTileFromTab(BuildContext context) {
    return Consumer<DrawerViewModel>(builder: (context, drawer, child) {
      debugPrint("[Size of tabsList: ${drawer.tabs.length}]");
      return ListView.builder(
        itemCount: drawer.tabs.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(title: Text(drawer.tabs[i].name));
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      );
    });
  }*/

