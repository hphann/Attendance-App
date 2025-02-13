import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentTitle = "Dashboard";

  String get currentTitle => _currentTitle;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void setCurrentTitle(String title) {
    _currentTitle = title;
    notifyListeners();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
