import 'dart:ui';
import 'package:fdnt/business_logic/viewmodels/drawer_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  //const DrawerView({Key key}) : super(key: key);

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
          createListTileFromTab(context),
        ],
      ),
    );
  }

  Widget createListTileFromTab(BuildContext context) {
    return Consumer<DrawerViewModel>(builder: (context, drawer, child) {
      debugPrint("[Size of tabsList: ${drawer.tabs.length}]");
      return ListView.builder(
        itemCount: drawer.tabs.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(title: Text(drawer.tabs[i].name));
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      );
    });
  }
}
