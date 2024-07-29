// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/models/sorted_member.dart';

class ApiFutureFarmers {
  final String baseUrl = "http://192.168.1.103:8000/api";

  Future<String?> _getToken() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'token' key.
    return prefs.getString('token');
  }

  Future<List> getFarmers() async {
    print('[GET FARMER API]');
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sorted-members-list/'),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // Handle the data as needed
        print(data);

        return data.map((i) => SortedMember.fromJson(i)).toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load user data');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
