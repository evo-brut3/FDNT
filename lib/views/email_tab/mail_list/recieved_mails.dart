import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_preview_view.dart';

class ReceivedMailsList extends StatelessWidget {
  final BuildContext context;
  final EmailListViewModel model;
  ReceivedMailsList({this.context, this.model});


  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        var metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          if (metrics.pixels != 0) {
            Provider.of<EmailListViewModel>(context, listen: false)
                .scrolledToBottom();
          }
        }
        return true;
      },
      child: ListView.builder(
          shrinkWrap: true,
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
                                dayTime: model.emails[index].sendTime
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

    );
  }
}