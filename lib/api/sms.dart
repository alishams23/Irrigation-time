// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiMotor {
  final String baseUrl = "http://192.168.1.103:8000/api";

  Future<String?> _getToken() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'token' key.
    print('token ${prefs.getString('token')}');
    return prefs.getString('token');
  }

  Future<void> turnOff() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/turn-off-water-well/'),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(response.body);
        // Handle the data as needed
        return data;
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load posts');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> turnOn() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/turn-on-water-well/'),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(response.body);
        // Handle the data as needed
        return data;
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load posts');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
