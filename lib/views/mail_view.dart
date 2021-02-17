
import 'package:fdnt/business_logic/models/mail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MailView extends StatelessWidget {
  final model = MailModel();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body : ListView.builder(
          itemCount: model.mailsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(model.mailsList[index]),
            );
          }
      )
    );
  }

}