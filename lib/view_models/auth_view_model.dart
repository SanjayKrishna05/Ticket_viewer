import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void login(String email, String role) {
    _currentUser = User(id: '1', name: 'John Doe', email: email, role: role);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
