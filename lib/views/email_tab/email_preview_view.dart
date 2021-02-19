import 'dart:convert';

import 'package:enough_mail/mime_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:webview_flutter/webview_flutter.dart';

class EmailPreviewView extends StatelessWidget {
  final String mimeMessage;
  WebViewController _controller;
  EmailPreviewView(this.mimeMessage);

  @override
  Widget build(BuildContext context) {
    debugPrint(mimeMessage);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              createInfoView(),
              createMessageView(),
            ],
          ),
        )),
      ),
      appBar: AppBar(),
    );
  }

  Widget createMessageView() {
    return Html(
      data: mimeMessage,
      shrinkWrap: true,
    );
  }

  Widget createInfoView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text("Obrazek"),
          Column(
            children: [
              Row(
                children: [Text("Biuro"), Text("12.04")],
              ),
              Text("do ja")
            ],
          ),
          Text("Odpowiedz"),
          Text("Dodatkowe"),
        ],
      ),
    );
  }
}
