import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = "https://jsonplaceholder.typicode.com";

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed GET $endpoint");
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed POST $endpoint");
    }
  }
}
