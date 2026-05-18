import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class ApiClient {
  static const _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
  static const _tokenKey = 'auth_token';
  static const _timeout = Duration(seconds: 15);

  final String baseUrl;
  String? _token;

  ApiClient({this.baseUrl = _defaultBaseUrl});

  Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, String>> _headers() async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final response = await http.get(uri, headers: await _headers()).timeout(_timeout);
    return _handle(response);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null).timeout(_timeout);
    return _handle(response);
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.patch(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null).timeout(_timeout);
    return _handle(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.delete(uri, headers: await _headers()).timeout(_timeout);
    return _handle(response);
  }

  dynamic _handle(http.Response response) {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }
    throw ApiException(response.statusCode, data?['detail'] ?? 'Request failed');
  }
}
