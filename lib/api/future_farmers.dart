// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/models/sorted_member.dart';

class ApiFutureFarmers {
  final String baseUrl = "https://farmabyar.ir/api";

  Future<String?> _getToken() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'token' key.
    return prefs.getString('token');
  }

  Future<List<SortedMember>> getFarmers() async {
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
        // Parse the JSON response
        var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        // Convert the list of dynamic maps to a list of SortedMember objects
        return data.map((i) => SortedMember.fromJson(i)).toList();
      } else {
        throw Exception('Failed to load user data');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
