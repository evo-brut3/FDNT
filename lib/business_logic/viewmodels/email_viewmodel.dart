import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/services/email_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session/flutter_session.dart';

class EmailListViewModel extends ChangeNotifier {
  List<EmailViewModel> emails = [];
  final emailPasswordTextController = TextEditingController();
  final _service = EmailService();

  bool get isLoggedToMailBox => _service.isConnected();

  Future<void> loginButtonClicked() async {
    dynamic email = (await FlutterSession().get("email")) as String;
    var password = emailPasswordTextController.text.trim().toString();

    await _service.connect(email, password);
    await fetchEmails();
    notifyListeners();

    final storage = FlutterSecureStorage();
    storage.write(key: CacheKey.mailboxLogin, value: email);
    storage.write(key: CacheKey.mailboxPassword, value: password);
  }

  Future<void> logoutButtonClicked() async {
    await _service.disconnect();
    notifyListeners();
  }

  Future<void> refreshIndicatorPulled() async {
    await fetchEmails();
  }

  Future<void> fetchEmails() async {
    final results = await _service.fetchEmails();
    this.emails = results.map((email) => EmailViewModel(email)).toList();
    notifyListeners();
  }

  Future<void> cacheCredentials({String login, String password}) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: CacheKey.mailboxLogin, value: login);
    await storage.write(key: CacheKey.mailboxPassword, value: password);
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
  set isEmailRead(bool val) => this.email.isRead = val;
}
