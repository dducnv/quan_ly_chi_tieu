import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/local/local_pref/pref_helper.dart';

class UserManagement {
  static final UserManagement _shared = UserManagement._initialState();
  static final PrefHelper prefHelper = PrefHelper();

  factory UserManagement() {
    return _shared;
  }

  /// Initial State
  UserManagement._initialState() {
    _preloadData();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @protected
  String _lastRoute = '';

  String get lastRoute => _lastRoute;
  void setLastRoute(String route) {
    _lastRoute = route;
  }

  int currentNavigator = 0;
  bool isShowPopupDetailsPageAds = true;
  bool isShowPopupTabcateAds = true;

  /// Preload data
  Future<void> _preloadData() async {
    // await prefHelper.init();
  }

  /// logout
  Future<void> logOut() async {}

  int currentButtonTab = 0;

  List<int> articleId = [];

  /// logout
  Future<void> addIdArticle(int id) async {
    articleId.add(id);
  }
}
