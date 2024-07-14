import 'package:flutter/material.dart';
import '../models/mother.dart';
import '../models/doctor.dart';

class AuthProvider with ChangeNotifier {
  Mother? _mother;
  Doctor? _doctor;
  bool _isLoggedIn = false;
  String? _password;

  Mother? get mother => _mother;
  Doctor? get doctor => _doctor;
  bool get isLoggedIn => _isLoggedIn;
  String? get password => _password;

  void checkLoginStatus() {
    // Check login status logic here
    // This is a placeholder example
    // Set _mother or _doctor based on login status
  }

  Future<void> logout() async {
    // Perform logout logic here
    _mother = null;
    _doctor = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void setLoginData(dynamic user, String password) {
    if (user is Mother) {
      _mother = user;
    } else if (user is Doctor) {
      _doctor = user;
    }
    _password = password;
    _isLoggedIn = true;
    notifyListeners();
  }
}
