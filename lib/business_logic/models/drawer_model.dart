import 'dart:collection';

import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:flutter/foundation.dart';

class DrawerModel extends ChangeNotifier {
  final List<Tab> _tabsList = [];

  UnmodifiableListView<Tab> get tabsList => UnmodifiableListView(_tabsList);

  void add(Tab tab) {
    _tabsList.add(tab);
    notifyListeners();
  }

  void clear() {
    _tabsList.clear();
    notifyListeners();
  }

  void addAll(List<Tab> tabs) {
    _tabsList.addAll(tabs);
    notifyListeners();
  }
}
