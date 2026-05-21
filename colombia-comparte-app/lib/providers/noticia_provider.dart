import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NoticiaProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _noticias = [];
  bool _isLoading = false;
  String _error = '';

  List<dynamic> get noticias => _noticias;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadNoticias() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _noticias = await _api.getNoticias();
    } catch (e) {
      _error = 'Error cargando noticias';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createNoticia(Map<String, dynamic> body) async {
    final ok = await _api.createNoticia(body);
    if (ok) await loadNoticias();
    return ok;
  }

  Future<bool> updateNoticia(String id, Map<String, dynamic> body) async {
    final ok = await _api.updateNoticia(id, body);
    if (ok) await loadNoticias();
    return ok;
  }

  Future<bool> toggleStatus(String id, String current) async {
    final newStatus = current == 'publicado' ? 'borrador' : 'publicado';
    final ok = await _api.updateNoticiaStatus(id, newStatus);
    if (ok) await loadNoticias();
    return ok;
  }

  Future<bool> deleteNoticia(String id) async {
    final ok = await _api.deleteNoticia(id);
    if (ok) await loadNoticias();
    return ok;
  }
}