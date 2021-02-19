import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/create_mail_view.dart';
import 'package:fdnt/views/email_tab/email_preview_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';


Widget EmailsListView(EmailListViewModel model) {
  return ListView.builder(
      itemCount: model.emails.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EmailPreviewView(model.emails[index].content)))
          },
          child: Row(
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
              SizedBox(
                height: 40,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(model.emails[index].senderName,
                        style: TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                        child: Text(model.emails[index].title,
                          style: TextStyle(color: Color(0xff878787)),
                          overflow: TextOverflow.ellipsis,
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text(model.emails[index].dayTime)],
                ),
              )
            ],
          ),
        );
      });
}