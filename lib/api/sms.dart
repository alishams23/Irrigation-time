import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceSms {
  final String baseUrl = "http://192.168.1.2:8000/api/11";

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    return [];
  }
}