
import 'package:fdnt/business_logic/models/mail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MailView extends StatelessWidget {
  final model = MailModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: model.mailsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Row (
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "assets/images/person_icon.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.mailsList[index].sender,
                      style: TextStyle(
                          fontSize: 17
                      )
                    ),
                    Text(
                        model.mailsList[index].title,
                        style: TextStyle(
                          color: Color(0xff878787),
                        )
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          model.mailsList[index].sendTime
                        )
                      ],
                  ),
                )
              ],
            );
          }
      )
    );
  }
}