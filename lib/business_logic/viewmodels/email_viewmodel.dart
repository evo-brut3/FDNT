import 'package:fdnt/business_logic/data_types/cache_keys.dart';
import 'package:fdnt/business_logic/data_types/email.dart';
import 'package:fdnt/services/email_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fdnt/features/flutter_session.dart';

class EmailListViewModel extends ChangeNotifier {
  List<EmailViewModel> emails = [];
  final emailPasswordTextController = TextEditingController();
  final _service = EmailService();
  final storage = FlutterSecureStorage();

  int emailsLeft;


  bool get isLoggedToMailBox => _service.isConnected();

  Future<void> loginButtonClicked() async {
    String password = emailPasswordTextController.text.trim().toString();
    if (password != "") {
      storage.write(key: CacheKey.mailboxPassword, value: password);
    }
    await startLogging();
  }

  Future<bool> startLogging() async {
    String email = await storage.read(key: CacheKey.mailboxLogin);
    String password = await storage.read(key: CacheKey.mailboxPassword);
    await _service.connect(email, password);
    if (_service.isConnected()) {
      loadEmails();
      return true;
    }
    return false;
  }

  Future<void> loadEmails() async {
    int emailsCount = await _service.emailsCount();
    emailsLeft = emailsCount;

    this.emails.clear();

    for (int i = emailsCount; i > emailsCount-8; i--) {
      await fetchEmails(i);
      emailsLeft--;
    }
  }

  Future<void> logoutButtonClicked() async {
    await _service.disconnect();
    notifyListeners();
  }

  Future<void> refreshIndicatorPulled() async {
    loadEmails();
    notifyListeners();
  }

  Future<void> scrolledToBottom() async {
    fetchEmails(emailsLeft);
    emailsLeft--;
  }

  Future<void> fetchEmails(int index) async {
    if (index >= 1) {
      final results = await _service.fetchEmails(index);
      this.emails.addAll(
          results.map((email) => EmailViewModel(email)).toList());
        notifyListeners();
    }
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
  String get title => this.email.title ?? "Bez tytułu";
  String get content => this.email.content;
  String get sendTime => email.dayTime();
  String get senderName => this.email.getSender;
  bool get isImportant => this.email.isImportant;
}
