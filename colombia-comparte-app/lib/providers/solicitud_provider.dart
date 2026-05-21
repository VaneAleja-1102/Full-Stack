import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SolicitudProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _solicitudes = [];
  bool _isLoading = false;
  String _error = '';
  String? filterStatus;
  String? filterCountry;

  List<dynamic> get solicitudes => _solicitudes;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadSolicitudes() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _solicitudes = await _api.getSolicitudes(
        status: filterStatus,
        country: filterCountry,
      );
    } catch (e) {
      _error = 'Error cargando solicitudes';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateStatus(String id, String status) async {
    final ok = await _api.updateSolicitudStatus(id, status);
    if (ok) await loadSolicitudes();
    return ok;
  }

  Future<bool> deleteSolicitud(String id) async {
    final ok = await _api.deleteSolicitud(id);
    if (ok) await loadSolicitudes();
    return ok;
  }

  void setFilterStatus(String? status) {
    filterStatus = status;
    loadSolicitudes();
  }

  void setFilterCountry(String? country) {
    filterCountry = country;
    loadSolicitudes();
  }
}