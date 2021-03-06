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

class _MainEmailViewState extends State<MainEmailView> {
  @override
  Widget build(BuildContext context) {
    EmailListViewModel emailListViewModel =
        Provider.of<EmailListViewModel>(context, listen: false);
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: emailListViewModel.refreshIndicatorPulled,
          child: Consumer<EmailListViewModel>(
              builder: (context, model, _) {
                if(model.isLoggedToMailBox)  {
                  return emailsListView(model, context);
                }
                else return loginToMailbox(context);
              }
          )
      ),
    );
  }



  Widget loginToMailbox(BuildContext context) {
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
              onPressed: () =>
                  Provider.of<EmailListViewModel>(context, listen: false)
                      .loginButtonClicked(),
              color: Colors.yellow,
            ),
            //padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          ),
        ),
      ],
    );
  }
}
