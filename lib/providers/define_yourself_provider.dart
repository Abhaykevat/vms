
import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  String? _selectedRole;
  bool _isLoading = false;

  String? get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;

  void selectRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _selectedRole = null;
    _isLoading = false;
    notifyListeners();
  }
}
