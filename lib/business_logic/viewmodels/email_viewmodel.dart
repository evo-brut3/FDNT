import 'package:enough_mail/enough_mail.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/email_service.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';

class EmailListViewModel extends ChangeNotifier {
  List<EmailViewModel> emails = [];

  Future<void> fetchEmails(String email, String mailboxPassword) async {
    EmailService service = EmailService();
    final results = await service.fetchImapEmails(email, mailboxPassword);
    this.emails = results.map((email) => EmailViewModel(email)).toList();
    notifyListeners();
  }
}

class EmailViewModel {
  final Email email;

  EmailViewModel(this.email);
  String get title => this.email.title;
  String get content => this.email.content;
  String get sendTime => this.email.sendTime;
  String get dayTime => this.email.dayTime();
  String get senderName => this.email.senderName;
  bool get isImportant => this.email.isImportant;
  bool get isRead => this.email.isRead;
}
