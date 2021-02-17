import 'dart:collection';
import 'package:flutter/foundation.dart';

class MailModel extends ChangeNotifier {
  final List<String> _mailsList = ["przykladowy1", "przykladowy2"];

  UnmodifiableListView<String> get mailsList => UnmodifiableListView(_mailsList);

  void add(String mail) {
    _mailsList.add(mail);
    notifyListeners();
  }

  void addAll(List<String> mails) {
    _mailsList.addAll(mails);
    notifyListeners();
  }
}
