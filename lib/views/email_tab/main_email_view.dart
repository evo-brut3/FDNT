import 'package:fdnt/business_logic/viewmodels/email_viewmodel.dart';
import 'package:fdnt/views/email_tab/emails_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:provider/provider.dart';

import 'create_mail_view.dart';

class MainEmailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainEmailViewState();
}

class _MainEmailViewState extends State<MainEmailView>{
  Future<bool> isLoggedToMailBox() async {
    dynamic temp = await FlutterSession().get("isLoggedToMailbox");
    String t = temp.toString();
    if(temp == null) return false;
    return t == "true";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool> (future: isLoggedToMailBox(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data) {
              return Consumer<EmailListViewModel>(
                  builder: (context, model, child) {
                    return emailsListView(model);
                  });
            } else {
              return loginToMailbox(context);
            }
          }),
      /*body:
        }
      ),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateMailView())
            );
          },
          child: Icon(Icons.add)
      ),
    );
  }
  Widget loginToMailbox(BuildContext context) {
    String password;
    return Column(
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
                onChanged: (text) => password = text,
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
                  dynamic email = (await FlutterSession().get("email")) as String;
                  debugPrint(password);
                  await Provider.of<EmailListViewModel>(context, listen: false)
                      .fetchEmails();
                  setState(() {});
                },
                color: Colors.yellow,
              ),
              //padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            ),
          ),
        ],
      );
  }
}
