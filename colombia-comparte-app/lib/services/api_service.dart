import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── PAÍSES ───────────────────────────────────────────────────────────────

  Future<List<dynamic>> getCountries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/countries'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return data['countries'];
    throw Exception(data['error_message']);
  }

  Future<bool> updateCountryStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/countries/$id/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteCountry(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/countries/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }

  // ─── SOLICITUDES ──────────────────────────────────────────────────────────

  Future<List<dynamic>> getSolicitudes({String? status, String? country}) async {
    String url = '$baseUrl/solicitudes';
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (country != null) params.add('country=$country');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final response = await http.get(Uri.parse(url), headers: await _headers());
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return data['solicitudes'];
    throw Exception(data['error_message']);
  }

  Future<Map<String, dynamic>> getSolicitud(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/solicitudes/$id'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return data['solicitud'];
    throw Exception(data['error_message']);
  }

  Future<bool> updateSolicitudStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/solicitudes/$id/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteSolicitud(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/solicitudes/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }

  // ─── TESTIMONIOS ──────────────────────────────────────────────────────────

  Future<List<dynamic>> getTestimonios() async {
    final response = await http.get(
      Uri.parse('$baseUrl/testimonios'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return data['testimonios'];
    throw Exception(data['error_message']);
  }

  Future<bool> createTestimonio(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/testimonios'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateTestimonio(String id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/testimonios/$id'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateTestimonioStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/testimonios/$id/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteTestimonio(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/testimonios/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }

  // ─── NOTICIAS ─────────────────────────────────────────────────────────────

  Future<List<dynamic>> getNoticias() async {
    final response = await http.get(
      Uri.parse('$baseUrl/noticias'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return data['noticias'];
    throw Exception(data['error_message']);
  }

  Future<bool> createNoticia(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/noticias'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateNoticia(String id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/noticias/$id'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateNoticiaStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/noticias/$id/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteNoticia(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/noticias/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }

  // ─── CONTACTO PÚBLICO ─────────────────────────────────────────────────────

  Future<bool> sendContactForm(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/solicitudes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }
}