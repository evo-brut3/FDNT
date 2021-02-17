import 'package:enough_mail/enough_mail.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:flutter/cupertino.dart';

class EmailService {
  String userName = 'konrad.startek';
  String domain = "dzielo.pl";
  String password = 'yCFRJIR!Tz7B';

  Future<List<Email>> fetchMails() async {
    List<Email> mails = [];

    final email = '$userName@$domain';
    print('discovering settings for  $email...');
    final config = await Discover.discover(email);

    if (config == null) {
      print('Unable to autodiscover settings for $email');
      return mails;
    }

    print('connecting to ${config.displayName}.');

    final account = MailAccount.fromDiscoveredSettings(
        'my account', email, password, config);
    final mailClient = MailClient(account, isLogEnabled: true);

    try {
      await mailClient.connect();
      print('connected');
      final mailboxes =
          await mailClient.listMailboxesAsTree(createIntermediate: false);

      print(mailboxes);

      await mailClient.selectInbox();
      final messages = await mailClient.fetchMessages(count: 3);
      for (final msg in messages) {
        mails.add(Email(
            title: msg.decodeSubject(),
            sender: msg.decodeSender().join(),
            sendTime: msg.decodeDate().toString(),
            content: msg.decodeTextPlainPart(),
            isRead: false,
            isImportant: false));

        debugPrint(msg.decodeTextPlainPart());
      }

      // mailClient.eventBus.on<MailLoadEvent>().listen((event) {
      //   print('New message at ${DateTime.now()}:');
      //   debugPrint(event.message.toString());
      // });
      // await mailClient.startPolling();
    } on MailException catch (e) {
      print('High level API failed with $e');
    }

    return mails;
  }
}
