import 'dart:convert';

import 'package:enough_mail/mime_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class EmailPreviewView extends StatelessWidget {
  final MimeMessage mimeMessage;
  WebViewController _controller;
  EmailPreviewView(this.mimeMessage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: WebView(
        initialUrl: "about:blank",
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _controller.loadUrl(Uri.dataFromString(
                  mimeMessage.decodeTextHtmlPart(),
                  mimeType: "text/html",
                  encoding: Encoding.getByName("utf8"))
              .toString());
        },
      ) //Text("mimeMessage.decodeTextHtmlPart()"),
          ),
      appBar: AppBar(),
    );
  }
}
