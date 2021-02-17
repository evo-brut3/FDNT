import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/email_service.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';

class EmailListViewModel extends ChangeNotifier {
  List<EmailViewModel> emails = [];

  Future<void> fetchEmails() async {
    final results = await EmailService().fetchMails();
    this.emails = results.map((email) => EmailViewModel(email: email)).toList();
    notifyListeners();
  }
}

class EmailViewModel {
  final Email email;

  EmailViewModel({this.email});

  String get title => this.email.title;
  String get content => this.email.content;
  String get sender => this.email.sender;
  String get sendTime => this.email.sendTime;
  bool get isImportant => this.email.isImportant;
  bool get isRead => this.email.isRead;
}
