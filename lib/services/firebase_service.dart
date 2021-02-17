import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<List<Tab>> fetchTabs() async {
    String userName = await AuthFirebase().userName;

    List<Tab> tabs = [];
    if (userName != null) {
      var tabsJson =
          (await databaseReference.child("users").child(userName).once()).value;

      for (var tab in tabsJson.keys) {
        String tabAddress = await getTabAdress(tabName: tab);
        tabs.add(Tab(name: tab, website: tabAddress, image: ""));
        debugPrint("[FirebaseService] Fetched new tab - $tab : $tabAddress");
      }
    } else {
      debugPrint("[FirebaseService] User is not correctly signed in");
    }

    return tabs;
  }

  Future<String> getTabAdress({String tabName}) async {
    return (await databaseReference
            .child("tabs")
            .child(tabName)
            .child("site")
            .once())
        .value;
  }
}
