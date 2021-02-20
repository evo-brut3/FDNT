import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/email_preview_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Widget emailsListView(EmailListViewModel model) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "assets/images/person_icon.png",
                  width: 50,
                  height: MediaQuery.of(context).size.height * 0.11,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.4,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0, 0, 0),
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