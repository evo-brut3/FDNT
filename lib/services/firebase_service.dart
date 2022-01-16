import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {

  final databaseReference = FirebaseDatabase.instance.reference();
  String userName = "";
  Future<List<Tab>> fetchTabs() async {
    try {
      userName = await AuthFirebase().userName;
    } on NoSuchMethodError {
      return [];
    }

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

  // If the user is on fdnt.pl then add him to the database
  // Return true if the action has been executed
  Future<bool> addFdntplUser({String email, String password}) async {
    debugPrint("$email -- $password");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    }
    on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('The password is too weak');
      }
      else if (error.code == 'email-already-in-use') {
        print('The account already exists for that email');
      }
    }
    catch (error) {
      print(error);
    }
  }
}
