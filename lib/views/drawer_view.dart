import 'dart:ui';

import 'package:fdnt/business_logic/models/drawer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  //const DrawerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<DrawerModel>(context, listen: true).tabsList.length;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("FDNT"),
            decoration: BoxDecoration(color: Colors.yellow),
          ),
          createListTileFromTab(),
        ],
      ),
    );
  }

  Widget createListTileFromTab() {
    return Consumer<DrawerModel>(builder: (context, drawer, child) {
      debugPrint("[Size of tabsList: ${drawer.tabsList.length}]");
      return ListView.builder(
        itemCount: drawer.tabsList.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(title: Text(drawer.tabsList[i].name));
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      );
    });
  }
}