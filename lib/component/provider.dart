import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late String adminCompanyName;
  late String userCompanyName;

  void setAdminCompanyName(String usercompanyName) {
    adminCompanyName = usercompanyName;
    notifyListeners();
  }

  void setuserCompanyName(String admincompanyName) {
    userCompanyName = admincompanyName;
    notifyListeners();
  }
}
