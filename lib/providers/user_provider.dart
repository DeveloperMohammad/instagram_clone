import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get user => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserInfo();
    _user = user;
    notifyListeners();
  }
}