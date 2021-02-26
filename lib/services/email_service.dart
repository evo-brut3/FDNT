import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_flutter/enough_mail_flutter.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
class EmailService {
  final client = ImapClient(isLogEnabled: false);
  String _domain = "dzielo.pl";
  String _imapServerHost = "mail.dzielo.pl";
  int _imapServerPort = 993;
  bool _isImapServerSecure = true;

  Future<List<Email>> fetchImapEmails(String email, String password) async {
    List<Email> mails = [];
    try {
      debugPrint("[EmailService] Connecting to the server...");
      await client.connectToServer(_imapServerHost, _imapServerPort,
          isSecure: _isImapServerSecure);

      debugPrint("[EmailService] Logging in...");
      await client.login(email, password);
      debugPrint("Success");
      await FlutterSession().set("isLoggedToMailbox", true);

      debugPrint("[EmailService] Listing mailboxes...");
      final mailboxes = await client.listMailboxes();
      mailboxes.forEach((element) {
        debugPrint("[EmailService] Mailbox found - $element");
      });
      debugPrint("[EmailService] Selecting the inbox...");
      await client.selectInbox();
      debugPrint("[EmailService] Fetching messages...");
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 3, criteria: "BODY.PEEK[]");
      fetchResult.messages.forEach((msg) {
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
      //await client.logout();
    } on ImapException catch (e) {
      debugPrint("[EmailService] Imap failed with $e");
    }
    return mails;
  }

  Future<FetchImapResult> downloadEmail(int messageSequenceId) async {
    return await client.fetchMessage(messageSequenceId, "BODY[]");
  }
}