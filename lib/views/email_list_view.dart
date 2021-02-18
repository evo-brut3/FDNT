import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_preview_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<EmailListViewModel>(builder: (context, model, child) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.emails[index].sender,
                          style: TextStyle(fontSize: 17)),
                      Text(model.emails[index].title,
                          style: TextStyle(
                            color: Color(0xff878787),
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text(model.emails[index].sendTime)],
                    ),
                  )
                ],
              ),
            );
          });
    }));
  }
}
