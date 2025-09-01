// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers());
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, {required Map<String, dynamic> body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(url, headers: _headers(), body: jsonEncode(body));
    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, {required Map<String, dynamic> body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(url, headers: _headers(), body: jsonEncode(body));
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers());
    return _processResponse(response);
  }

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    // Add Authorization header if needed
  };

  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception('Error ${response.statusCode}: ${body?['message'] ?? response.body}');
    }
  }
}
