import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_flutter/enough_mail_flutter.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';

class EmailService {
  // String _email;
  // String _password;

  // set email(String email) {
  //   _email = email;
  // }

  // set password(String password) {
  //   _password = password;
  // }

  MailAccount _account;
  MailClient _client;

  // String _domain = "dzielo.pl";
  // String _imapServerHost = "mail.dzielo.pl";
  // int _imapServerPort = 993;
  // bool _isImapServerSecure = true;

  Future<void> connect(String email, String password) async {
    debugPrint("[EmailService] Discovering settings...");
    final config = await Discover.discover(email);
    _account =
        MailAccount.fromDiscoveredSettings("Account", email, password, config);
    _client = MailClient(_account);

    try {
      debugPrint("[EmailService] Logging in...");
      await _client.connect();
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
    return _client?.isConnected ?? false;
  }

  Future<List<Email>> fetchEmails() async {
    List<Email> mails = [];
    try {
      // debugPrint("[EmailService] Connecting to the server...");
      // await _client.connect();

      // await FlutterSession().set("isLoggedToMailbox", true);

      debugPrint("[EmailService] Listing mailboxes...");
      final mailboxes = await _client.listMailboxes();
      mailboxes.forEach((element) {
        debugPrint("[EmailService] Mailbox found - $element");
      });
      debugPrint("[EmailService] Selecting the inbox...");
      await _client.selectInbox();
      debugPrint("[EmailService] Fetching messages...");
      final fetchResult = await _client.fetchMessages(
          count: 3, fetchPreference: FetchPreference.full);
      fetchResult.forEach((msg) {
        mails.insert(
            0,
            Email(
                title: msg.decodeSubject(),
                sender: msg.decodeSender().join(),
                sendTime: msg.decodeDate().toString(),
                // TODO: Download message only when user wants to display it
                content: msg.transformToHtml(),
                isRead: false,
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
