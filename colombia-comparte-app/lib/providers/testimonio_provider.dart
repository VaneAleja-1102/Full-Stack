import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:app/providers/testimonio_provider.dart';
class TestimonioProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _testimonios = [];
  bool _isLoading = false;
  String _error = '';

  List<dynamic> get testimonios => _testimonios;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadTestimonios() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _testimonios = await _api.getTestimonios();
    } catch (e) {
      _error = 'Error cargando testimonios';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTestimonio(Map<String, dynamic> body) async {
    final ok = await _api.createTestimonio(body);
    if (ok) await loadTestimonios();
    return ok;
  }

  Future<bool> updateTestimonio(String id, Map<String, dynamic> body) async {
    final ok = await _api.updateTestimonio(id, body);
    if (ok) await loadTestimonios();
    return ok;
  }

  Future<bool> toggleStatus(String id, String current) async {
    final newStatus = current == 'publicado' ? 'despublicado' : 'publicado';
    final ok = await _api.updateTestimonioStatus(id, newStatus);
    if (ok) await loadTestimonios();
    return ok;
  }

  Future<bool> deleteTestimonio(String id) async {
    final ok = await _api.deleteTestimonio(id);
    if (ok) await loadTestimonios();
    return ok;
  }
}