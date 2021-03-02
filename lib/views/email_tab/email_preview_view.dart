
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
      appBar: CustomAppBar(title: 'Poczta', isReturnIconEnabled: true),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Html(
        data: content,
        shrinkWrap: true,
      ),
    );
  }

  Widget createInfoView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                        title,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 23),
                    ),
                  ),

                ],
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Text(senderName, style: TextStyle(fontSize: 17,
                        fontWeight: FontWeight.bold)),
                  ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                      child: Text(dayTime, style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left),
                    ),
                    GestureDetector(
                      child: Transform.scale(
                        scale: 1.2,
                        child: Container(
                            child: Icon(Icons.reply)
                        ),
                      ),
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMailView()))
                      },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
