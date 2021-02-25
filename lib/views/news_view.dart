import 'dart:convert';
import 'dart:typed_data';

import 'package:fdnt/business_logic/data_types/post.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/business_logic/viewmodels/news_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends StatelessWidget {
  String getCoverImage(String html) {
    int t = html.indexOf('data:image/');
    if (t == -1) return "";
    return html.substring(t, html.indexOf('">', t));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<NewsListViewModel>(context, listen: false).fetchNews();

    return Scaffold(
        body: Consumer<NewsListViewModel>(builder: (context, model, child) {
      return ListView.builder(
          itemCount: model.posts.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewsShow(model.posts[index])))
                    },
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(children: [
                          Container(
                              height: 200,
                              child: Container(
                                child: Html(
                                  data: """
                        <body><div><img src='##'></div></body>
                        """
                                      .replaceAll(
                                          "##",
                                          getCoverImage(
                                              model.posts[index].html)),
                                  style: {
                                    "body": Style(
                                      margin: EdgeInsets.zero,
                                    ),
                                    "div": Style()
                                  },
                                ),
                              )),
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(model.posts[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ))),
                          // This widget is added to catch taps on image (otherwise it thew errors)
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 40,
                              top: 0,
                              child: Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.grey.withOpacity(0.02))))
                        ]))));
          });
    }));
  }
}

class NewsShow extends StatelessWidget {
  final NewsViewModel post;
  NewsShow(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
          margin: MediaQuery.of(context).padding,
          child: Row(children: [
            BackButton(),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(post.title, style: TextStyle(fontSize: 20)))
          ])),
      SingleChildScrollView(
        child: Html(data: post.html),
      )
    ]));
  }
}
