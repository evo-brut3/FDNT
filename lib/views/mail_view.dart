
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body : ListView.builder(
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("List item $index")
            );
          }
      )
    );
  }

}