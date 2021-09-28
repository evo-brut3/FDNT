import 'package:fdnt/business_logic/data_types/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fdnt/business_logic/data_types/tab.dart';
import 'package:fdnt/services/firebase_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NewsListViewModel extends ChangeNotifier {
  List<NewsViewModel> posts = [];

  Future<void> fetchNews() async {
    final results = await FirebaseService().fetchTabs();
    this.posts = results.map((tab) => NewsViewModel(tab: tab)).toList();
    notifyListeners();
  }
}

class NewsViewModel {
  final Tab tab;
  NewsViewModel({this.tab});
  String get title => this.tab.name;
  String get html => this.tab.website;
}