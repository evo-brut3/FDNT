
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'create_mail_view.dart';

class EmailPreviewView extends StatelessWidget {
  final String content;
  final String senderName;
  final String dayTime;
  final String title;
  EmailPreviewView(
      {this.title, this.senderName, this.content, this.dayTime});

  @override
  Widget build(BuildContext context) {
    debugPrint(content);

    return Scaffold(
      appBar: CustomAppBar(title: '', onTap: () => {
       Navigator.pop(context)
      }),
      body: Container(
        child: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                createInfoView(context),
                Center(child: createMessageView()),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget createMessageView() {
    return Html(
      data: content,
      shrinkWrap: true,
    );
  }

  Widget createInfoView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        title,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                        image: AssetImage('assets/images/reply.png'),
                    ),
                    onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMailView()))
                    },
                  )
                ],
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Text(senderName),
                      Text(dayTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
