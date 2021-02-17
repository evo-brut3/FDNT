
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
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                            model.mailsList[index].sender,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            )
                        )

                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: Text(
                        model.mailsList[index].title,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
      )
    );
  }
}