
import 'package:flutter/cupertino.dart';

class BottomNavigatinBarProvider extends ChangeNotifier {
  int selectedCurrentIndex = 0;

  void bottomNavigationChange(int index) {
    selectedCurrentIndex = index;
    notifyListeners();
  }
}
