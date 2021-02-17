import 'dart:collection';
import 'package:fdnt/business_logic/data_types/mail.dart';
import 'package:flutter/foundation.dart';

class MailModel extends ChangeNotifier {
  final List<Mail> _mailsList = [
    Mail("tytuł", "john doe", "12:00", "wololololoolololololoolololololololo",
        false, false)
  ];

  UnmodifiableListView<Mail> get mailsList => UnmodifiableListView(_mailsList);

  void add(Mail mail) {
    _mailsList.add(mail);
    notifyListeners();
  }

  void clear() {
    _mailsList.clear();
    notifyListeners();
  }

  void addAll(List<Mail> mails) {
    _mailsList.addAll(mails);
    notifyListeners();
  }
}
