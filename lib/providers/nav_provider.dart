
import 'package:flutter/material.dart';
import 'package:vms/screens/admin_dashboard.dart';
import 'package:vms/screens/manage_logscreen.dart';

class NavProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> _pages = [
    AdminDashboard(),
    Center(child: Text("Dashboard")),
    ManageLogscreen(),
    Center(child: Text("Profile")),
  ];

  List<Widget> get pages => _pages;
}
