import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_flutter/enough_mail_flutter.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:flutter/cupertino.dart';

class EmailService {
  final client = ImapClient(isLogEnabled: false);

  String _userName = 'konrad.startek@dzielo.pl';
  String _domain = "dzielo.pl";
  String _password = 'yCFRJIR!Tz7B';

  String _imapServerHost = "mail.dzielo.pl";
  int _imapServerPort = 993;
  bool _isImapServerSecure = true;

  Future<List<Email>> fetchImapEmails() async {
    List<Email> mails = [];

    try {
      debugPrint("[EmailService] Connecting to the server...");
      await client.connectToServer(_imapServerHost, _imapServerPort,
          isSecure: _isImapServerSecure);

      debugPrint("[EmailService] Logging in...");
      await client.login(_userName, _password);

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

      await client.logout();
    } on ImapException catch (e) {
      debugPrint("[EmailService] Imap failed with $e");
    }

    return mails;
  }

  Future<FetchImapResult> downloadEmail(int messageSequenceId) async {
    return await client.fetchMessage(messageSequenceId, "BODY[]");
  }

  // Future<List<Email>> fetchMails() async {
  //   List<Email> mails = [];

  //   final email = '$_userName@$_domain';
  //   print('discovering settings for  $email...');
  //   final config = await Discover.discover(email);

  //   if (config == null) {
  //     print('Unable to autodiscover settings for $email');
  //     return mails;
  //   }

  //   print('connecting to ${config.displayName}.');

  //   final account = MailAccount.fromDiscoveredSettings(
  //       'my account', email, _password, config);
  //   final mailClient = MailClient(account, isLogEnabled: true);

  //   try {
  //     await mailClient.connect();
  //     print('connected');
  //     final mailboxes =
  //         await mailClient.listMailboxesAsTree(createIntermediate: false);

  //     print(mailboxes);

  //     await mailClient.selectInbox();
  //     final messages = await mailClient.fetchMessages();
  //     for (final msg in messages) {
  //       mails.add(Email(
  //           title: msg.decodeSubject(),
  //           sender: msg.decodeSender().join(),
  //           sendTime: msg.decodeDate().toString(),
  //           content: msg.decodeTextPlainPart(),
  //           isRead: false,
  //           isImportant: false));

  //       debugPrint(msg.decodeTextPlainPart());
  //     }

  //     // mailClient.eventBus.on<MailLoadEvent>().listen((event) {
  //     //   print('New message at ${DateTime.now()}:');
  //     //   debugPrint(event.message.toString());
  //     // });
  //     // await mailClient.startPolling();
  //   } on MailException catch (e) {
  //     print('High level API failed with $e');
  //   }

  //   return mails;
  // }
}
