import 'package:flutter/material.dart';

class mainScreenNotifier extends ChangeNotifier {
  int _pageindex = 0;
  int get pageIndex => _pageindex;

  set pageIndex(int newIndex) {
    _pageindex = newIndex;
    notifyListeners();
  }
}
