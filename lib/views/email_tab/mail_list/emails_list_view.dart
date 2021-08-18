
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/mail_list/recieved_mails.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          _scaffoldBody = ReceivedMailsList(context: context, model: model);
          break;
        case 1:
          _scaffoldBody = ReceivedMailsList(context: context, model: model);
          break;
        case 2:
          _scaffoldBody = ReceivedMailsList(context: context, model: model);
          break;
        case 3:
          _scaffoldBody = ReceivedMailsList(context: context, model: model);
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