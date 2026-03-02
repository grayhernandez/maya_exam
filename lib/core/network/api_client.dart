import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<dynamic> get(String path) async {
    final res = await client.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('GET $path failed: ${res.statusCode}');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('POST $path failed: ${res.statusCode}');
  }
}
