import 'dart:ui';

import 'package:fdnt/business_logic/models/drawer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  //const DrawerView({Key key}) : super(key: key);

  final model = DrawerModel();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("FDNT"),
            decoration: BoxDecoration(color: Colors.yellow),
          ),
          ListTile(
            title: Text("Test"),
          ),
        ],
      ),
    );
  }
}
