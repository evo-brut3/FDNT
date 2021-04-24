import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/drawer_view.dart';
import 'package:fdnt/views/email_tab/mail_list/emails_list_view.dart';
import 'package:fdnt/views/pieces/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:provider/provider.dart';

import 'mail_list/mail_compose/create_mail_view.dart';

class MainEmailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainEmailViewState();
}

class _MainEmailViewState extends State<MainEmailView> {
  @override
  Widget build(BuildContext context) {
    EmailListViewModel emailListViewModel =
        Provider.of<EmailListViewModel>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<EmailListViewModel>(
              builder: (context, model, _) {
                if(model.isLoggedToMailBox)  {
                  return EmailsListView(model: model);
                }
                else {
                  //final store = FlutterSecureStorage();
                  //String password = await store.read(key: CacheKey.mailboxPassword);
                  return loginToMailbox(context);
                }
              }
          )
      );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget loginToMailbox(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "O Fundacji",
      ),
      drawer: drawerView(context: context),
      body: Column(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              alignment: Alignment.center,
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  labelText: "Hasło",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                ),
                obscureText: true,
                controller:
                    Provider.of<EmailListViewModel>(context, listen: false)
                        .emailPasswordTextController,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: ProgressButton(
                borderRadius: 8.0,
                defaultWidget: Text("Zaloguj się do poczty"),
                animate: true,
                progressWidget: CircularProgressIndicator(),
                onPressed: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: _scaffoldKey.currentContext,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator());
                    });
                  await Provider.of<EmailListViewModel>(context, listen: false)
                      .loginButtonClicked();
                  Navigator.of(_scaffoldKey.currentContext).pop();
                },
                color: Colors.yellow,
              ),
              //padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            ),
          ),
        ],
      ),
    );
  }
}
