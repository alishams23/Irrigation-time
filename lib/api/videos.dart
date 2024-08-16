// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_sort/models/video.dart';

class ApiVideoService {
  final String baseUrl = "https://farmabyar.ir/api";

  Future<List<Video>> fetchVideos() async {
    print('[FETCH VIDEO API]');
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/video/video-list-api'),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        print('[REQUEST CODE: 200]');
        // If the server returns a 200 OK response, parse the JSON
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        // Convert the data to a list of Video objects
        return (data as List).map((item) => Video.fromJson(item)).toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load video data');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
