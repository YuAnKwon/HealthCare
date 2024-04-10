import 'dart:convert';
import 'package:healthcare/http/Api_Resource.dart';
import 'package:http/http.dart' as http;

class DataFetcher {
  static Future<Map<String, dynamic>> fetchData() async {
    Map<String, dynamic> data = {};
    final response = await http.get(
      Uri.parse('${ApiResource.serverUrl}/main'),
      headers: {
        'ngrok-skip-browser-warning': '69420',
      },
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
    return data;
  }
}
