import 'package:fdnt/business_logic/viewmodels/news_viewmodel.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class NewsView extends StatelessWidget {
  String getCoverImage(String html) {
    int t = html.indexOf('data:image/');
    if (t == -1) return "";
    return html.substring(t, html.indexOf('">', t));
  }

  final bool isUserLogged;
  NewsView({this.isUserLogged});
  @override
  Widget build(BuildContext context) {
    Provider.of<NewsListViewModel>(context, listen: false).fetchNews();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Ogłoszenia",
      ),
      body: isUserLogged
          ? Consumer<NewsListViewModel>(builder: (context, model, child) {
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(children: [
                                  Container(
                                      height: 200,
                                      child: Container(
                                        child: FutureBuilder<String>(
                                          future: getBackgroundImageUrl(model.posts[index].html),
                                          builder: (context, snapshot) {
                                            List<Widget> children;
                                            if (snapshot.hasData) {
                                                children = [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(snapshot.data)
                                                      )
                                                    ),
                                                  )
                                                ];
                                            } else {
                                                children = [
                                                  Center(child: CircularProgressIndicator())
                                                ];
                                            }
                                            return Center(
                                              child: Column(
                                                children: children,
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: new Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.grey.withOpacity(0.7),
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Text(
                                                model.posts[index].title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ))),
                                  // This widget is added to catch taps on image (otherwise it thew errors)
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 40,
                                      top: 0,
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.grey
                                                  .withOpacity(0.02))))
                                ]))));
                  });
            })
          : Center(
            child: Container(
                child: Text(
                    "Po zalogowaniu pojawią się tutaj posty",
                    style: TextStyle(fontSize: 20),
                ),
              ),
          ),
    );
  }
}

Future<String> getBackgroundImageUrl(String webpageUri) async {
  String html = await fetchWebpageHtml(webpageUri);
  //after this specific html part background image code starts
  String needle = '<div class="IFuOkc"';
  int index = html.indexOf(needle);
  if (index == -1) throw Exception('error: image not found');

  // remove all signs to the start of needle
  html = html.substring(html.indexOf(needle) + needle.length);
  //remove all chars to the first occurence of </div>
  html = html.substring(0, html.indexOf('</div>'));

  // extract background image url
  String imgHtmlSrc = html.substring(
      html.indexOf('https://'),
      html.indexOf(')')
  );
  return imgHtmlSrc;
}

// Download site content
Future<String> fetchWebpageHtml(String url) async {
  Uri uri = Uri.parse(url);
  http.Response response = await http.get(uri);
  return response.body;
}
class NewsShow extends StatelessWidget {
  final NewsViewModel post;
  NewsShow(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Expanded(
                    child: WebView(
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: post.html))
              ],
            )));
  }

  // Previous post showing
/*
          Column(
            children: [
              Expanded(
                  child: WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: post.html))
            ],
          )
 */
}
