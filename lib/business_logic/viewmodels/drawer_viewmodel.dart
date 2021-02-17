import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';

class DrawerViewModel extends ChangeNotifier {
  List<TabViewModel> tabs = [];

  Future<void> fetchTabs() async {
    final results = await FirebaseService().fetchTabs();
    this.tabs = results.map((tab) => TabViewModel(tab: tab)).toList();
    notifyListeners();
  }
}

class TabViewModel {
  final Tab tab;

  TabViewModel({this.tab});

  String get name {
    return this.tab.name;
  }

  String get website {
    return this.tab.website;
  }

  String get image {
    return this.tab.image;
  }
}
