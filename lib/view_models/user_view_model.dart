import 'package:flutter/material.dart';
import '../models/user.dart';
import '../views/auth/login_view.dart';

class UserViewModel extends ChangeNotifier {
  final List<User> _users = [];
  User? _currentUser;

  List<User> get users => _users;
  User? get currentUser => _currentUser;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void deleteUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    _currentUser = null;
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginView()),
          (Route<dynamic> route) => false,
    );
  }
}
