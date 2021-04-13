import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

final toController = TextEditingController();
final subjectController = TextEditingController();
final contentController = TextEditingController();

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
        onPressed: () {sendEmail(context);},
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
          controller: toController,
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
          controller: subjectController,
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
          controller: contentController,
          maxLines: null,
          decoration:
              InputDecoration.collapsed(hintText: "Tutaj wpisz treść maila"),
          style: TextStyle(fontSize: bodyFontSize),
        ),
      ),
    );
  }
}

Future<void> sendEmail(BuildContext context) async {
  final storage = new FlutterSecureStorage();
  String username = await storage.read(key: CacheKey.mailboxLogin);
  String password = await storage.read(key: CacheKey.mailboxPassword);

  final smtpServer = SmtpServer("mail.dzielo.pl",
      username: username, password: password);

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(toController.text.trim().toString())
    ..subject = subjectController.text.trim().toString()
    ..text = contentController.text.trim().toString();

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n'+ e.toString());
  }

  // Close sending view.
  Navigator.pop(context, true);
}
