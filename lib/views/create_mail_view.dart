import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateMailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createMailForm()
    );
  }

  Widget createMailForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Do:"
              ),
            ),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Tytuł: "
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: TextFormField(
              maxLines: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Tutaj wpisz treść maila"
              ),
            ),
          )
        ],
      ),
    );
  }
}