import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';

class EmailService {
  ImapClient _client;

   String _imapServerHost = "mail.dzielo.pl";
   int _imapServerPort = 993;
   bool _isImapServerSecure = true;

  Future<void> connect(String email, String password) async {
    try {
      _client = ImapClient(isLogEnabled: false);

      await _client.connectToServer(_imapServerHost, _imapServerPort,
            isSecure: _isImapServerSecure);
      await _client.login(email, password);

      debugPrint("[EmailService] Logging in...");
      await FlutterSession().set("isLoggedToMailbox", true);
    } on MailException catch (e) {
      await FlutterSession().set("isLoggedToMailbox", false);
      debugPrint("[EmailService] High level API failed with $e");
    }

    if (isConnected() == true) {
      debugPrint("[EmailService] Successfully established connection");
    }
  }

  Future<void> disconnect() async {
    await _client.disconnect();
  }

  bool isConnected() {
    return _client?.isLoggedIn ?? false;
  }

  Future<int> emailsCount() async {
    final box = await _client.selectInbox();
    return box.messagesExists;
  }

  Future<List<Email>> fetchEmails(int index) async {
    emailsCount();
    List<Email> mails = [];
    try {
      debugPrint("[EmailService] Selecting the inbox...");
      await _client.selectInbox();
      debugPrint("[EmailService] Fetching messages...");
      final fetchResult = await _client.fetchMessage(index, "BODY[]");
      fetchResult.messages.forEach((msg) {
        mails.insert(
            0,
            Email(
                title: msg.decodeSubject(),
                sender: msg.decodeSender().join(),
                sendTime: msg.decodeDate(),
                // TODO: Download message only when user wants to display it
                content: msg.transformToHtml(),
                isImportant: false));
        debugPrint(msg.decodeTextPlainPart());
      });
    } on MailException catch (e) {
      debugPrint("[EmailService] Imap failed with $e");
    }


    return mails;
  }

  Future<void> sendEmail() async {}
}
