// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/models/group.dart';

class ApiSortGroupMemberList {
  final String baseUrl = "https://farmabyar.ir/api";

  Future<String?> _getToken() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'token' key.
    return prefs.getString('token');
  }

  Future<List<Group>> fetchFarmerGroups() async {
    print('[FETCH FARMER GROUPS API]');
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/group-list-api-view/'),
        headers: {
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        // Convert the JSON list to a list of Group objects
        return data.map((group) => Group.fromJson(group)).toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load farmer groups');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateGroup(List<Map<String, dynamic>> updatedData) async {
    print('[UPDATE GROUPS SORT ORDER API]');
    print(updatedData);

    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/group-sort-update-view/'),
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(updatedData), // Send the entire list
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200] Groups updated successfully');
      } else {
        throw Exception('Failed to update groups');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateMember(List<Map<String, dynamic>> updatedData) async {
    print('[UPDATE MEMBER SORT ORDER API]');
    print(updatedData);

    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/members-sort-update-view/'),
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(updatedData), // Send the entire list
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200] Members updated successfully');
      } else {
        throw Exception('Failed to update members');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateMemberTime(int id, int time) async {
    print('[UPDATE MEMBER TIME API]');
    print('Member ID: $id, Time: $time');

    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/member-time-update-view/$id/'),
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'time': time,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200] Member time updated successfully');
      } else {
        throw Exception('Failed to update member time');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateWaterWellCurrentMember(int currentMember, int startMember) async {
    print('[UPDATE WATER WELL CURRENT MEMBER API]');
    print('Current Member: $currentMember, Start Member: $startMember');

    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/water-well-current-member-update/'),
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'current_member': currentMember,
              'start_member': startMember,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200] Water well current member updated successfully');
      } else {
        throw Exception('Failed to update water well current member');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
