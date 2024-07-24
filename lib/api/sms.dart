// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceSms {
  final String baseUrl = "http://192.168.1.2:8000/api/11";

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    return [];
  }
}
