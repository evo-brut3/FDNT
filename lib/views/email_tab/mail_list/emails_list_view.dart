
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/mail_list/email_preview_view.dart';
import 'package:fdnt/views/email_tab/mail_list/recieved_mails.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../drawer_view.dart';
import 'mail_compose/create_mail_view.dart';

class EmailsListView extends StatefulWidget {

  final EmailListViewModel model;

  EmailsListView({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailsListViewState(model);
}

class _EmailsListViewState extends State<EmailsListView> {

  final EmailListViewModel model;
  _EmailsListViewState(this.model);

  int _selectedDestination = 0;
  Widget _scaffoldBody;
  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
      switch(index) {
        case 0:
          _scaffoldBody = ReceivedMailsList(context: context);
          break;
        case 1:
          _scaffoldBody = ReceivedMailsList(context: context);
          break;
        case 2:
          _scaffoldBody = ReceivedMailsList(context: context);
          break;
        case 3:
          _scaffoldBody = ReceivedMailsList(context: context);
          break;
        default:
          _scaffoldBody = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    selectDestination(_selectedDestination);

    return Scaffold(
        appBar: CustomAppBar(title: "O Fundacji",),
        drawer: drawerView(context: context, items: Column(
            children: [
                ListTile(
                  title: Text("Odebrane"),
                  leading: Icon(Icons.inbox),
                  selected: _selectedDestination == 0,
                  onTap: () => selectDestination(0),
                ),
                ListTile(
                    title: Text("Wysłane"),
                    leading: Icon(Icons.send),
                    selected: _selectedDestination == 1,
                    onTap: () => selectDestination(1)
                ),
                ListTile(
                    title: Text("Robocze"),
                    leading: Icon(Icons.drafts),
                    selected: _selectedDestination == 2,
                    onTap: () => selectDestination(2)
                ),
                ListTile(
                    title: Text("Kosz"),
                    leading: Icon(Icons.delete),
                    selected: _selectedDestination == 3,
                    onTap: () => selectDestination(3)
                )
              ]),

        ),
        floatingActionButton: writeMailBtn(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: _scaffoldBody
    );

  }
}


Widget writeMailBtn(BuildContext context) {
  return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateMailView()));
      },
      label: Text("Utwórz"),
      icon: Icon(
        Icons.create,
      )
  );
}