import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();

  String _name = '';
  String _role = '';
  String _country = '';
  bool _isLoading = false;
  String _error = '';

  String get name => _name;
  String get role => _role;
  String get country => _country;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isSuperAdmin => _role == 'superadmin';
  bool get isAdminPais => _role == 'admin_pais';
  bool get isEditor => _role == 'editor';

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _role = prefs.getString('role') ?? '';
    _country = prefs.getString('country') ?? '';
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    if (result['ok'] == true) {
      await loadUser();
      notifyListeners();
      return result['role'];
    } else {
      _error = result['message'];
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _name = '';
    _role = '';
    _country = '';
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }
}