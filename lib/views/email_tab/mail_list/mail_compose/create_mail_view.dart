import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMailView extends StatelessWidget {
  static const mainOpacity = 0.7;
  static const detailsFontSize = 16.0;
  static const bodyFontSize = 18.0;
  static const defaultHorizontalPadding = 16.0;
  static const defaultPadding = EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Utwórz"),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(opacity: mainOpacity),
        elevation: 0.0,
        actions: [
          IconButton(icon: Icon(Icons.attachment), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: createMailForm(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Wyślij"),
        icon: Icon(Icons.send),
      ),
    );
  }

  Widget createMailForm() {
    return Column(
      children: [
        Divider(height: 20, color: Colors.black.withOpacity(0.1)),
        recipientFormField(),
        Divider(height: 20, color: Colors.black.withOpacity(0.1)),
        topicFormField(),
        Divider(height: 20, color: Colors.black.withOpacity(0.1)),
        bodyFormField()
      ],
    );
  }

  Widget recipientFormField() {
    return Padding(
      padding: defaultPadding,
      child: Container(
        child: TextFormField(
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Text("Do:",
                style: TextStyle(
                    fontSize: detailsFontSize,
                    color: Colors.black.withOpacity(mainOpacity))),
            prefixIconConstraints: BoxConstraints(minHeight: 0, minWidth: 50),
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: detailsFontSize),
        ),
      ),
    );
  }

  Widget topicFormField() {
    return Container(
      child: Padding(
        padding: defaultPadding,
        child: TextFormField(
          decoration: InputDecoration(
            isDense: true,
            hintText: "Temat:",
            hintStyle: TextStyle(
                fontSize: bodyFontSize,
                color: Colors.black.withOpacity(mainOpacity)),
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: bodyFontSize),
        ),
      ),
    );
  }

  Widget bodyFormField() {
    return Padding(
      padding: defaultPadding,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: TextFormField(
          maxLines: null,
          decoration:
              InputDecoration.collapsed(hintText: "Tutaj wpisz treść maila"),
          style: TextStyle(fontSize: bodyFontSize),
        ),
      ),
    );
  }
}
