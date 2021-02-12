import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> getTabs() async {
    var tabs =
        (await databaseReference.child("users").child("konradstartek").once())
            .value;

    print("$tabs");
  }
}
