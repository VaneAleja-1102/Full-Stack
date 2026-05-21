import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CountryProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _countries = [];
  bool _isLoading = false;
  String _error = '';

  List<dynamic> get countries => _countries;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadCountries() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _countries = await _api.getCountries();
    } catch (e) {
      _error = 'Error cargando países';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleStatus(String id, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    final ok = await _api.updateCountryStatus(id, newStatus);
    if (ok) await loadCountries();
    return ok;
  }

  Future<bool> deleteCountry(String id) async {
    final ok = await _api.deleteCountry(id);
    if (ok) await loadCountries();
    return ok;
  }
}