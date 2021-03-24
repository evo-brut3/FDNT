
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/email_preview_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'create_mail_view.dart';

Widget emailsListView(EmailListViewModel model, BuildContext baseContext) {
  return Scaffold(
    floatingActionButton: writeMailBtn(baseContext),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    body: NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        var metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            if (metrics.pixels != 0) {
              Provider.of<EmailListViewModel>(baseContext, listen: false)
                  .scrolledToBottom();
            }
          }
        return true;
        },
      child: ListView.builder(
        itemCount: model.emails.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmailPreviewView(
                            title: model.emails[index].title,
                            senderName: model.emails[index].senderName,
                            content: model.emails[index].content,
                            dayTime: model.emails[index].dayTime
                          )
                  )
              )
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          model.emails[index].senderName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Flexible(
                          child: Text(model.emails[index].title,
                            style: TextStyle(
                                color: Color(0xff878787),
                                fontWeight: FontWeight.normal
                            ),
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
                    children: [Text(model.emails[index].sendTime)],
                  ),
                )
              ],
            ),
          );
        }),

  ));

}
Widget writeMailBtn(BuildContext context) {
  return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateMailView()));
      },
      label: Text("Utwórz"),
      icon: Icon(
        Icons.create,
      )
  );
}