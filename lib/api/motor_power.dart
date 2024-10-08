// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/models/water_well.dart';

class ApiMotorPower {
  final String baseUrl = "https://farmabyar.ir/api";

  Future<String?> _getToken() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'token' key.
    return prefs.getString('token');
  }

  Future<void> turnOff(String? id) async {
    print('[TURN OFF MOTOR API]');
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      String url = id != null ? '$baseUrl/turn-off-water-well/$id/' : '$baseUrl/turn-off-water-well/';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load posts');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> turnOn(String? id) async {
    print('[TURN ON MOTOR API]');
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      String url = id != null ? '$baseUrl/turn-on-water-well/$id/' : '$baseUrl/turn-on-water-well/';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load posts');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<WaterWell> getStatus() async {
    print('[GET STATUS API]');
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/water-well-status/'),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // Handle the data as needed
        WaterWell status = WaterWell.fromJson(data);
        final prefs = await SharedPreferences.getInstance();
        if (status.isAdmin) {
          prefs.setString('full_name', '${status.fullName}⭐️');
          prefs.setString('is_admin', 'true');
        } else {
          prefs.setString('full_name', status.fullName);
          prefs.setString('is_admin', 'false');
        }
        return status;
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load user data');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
