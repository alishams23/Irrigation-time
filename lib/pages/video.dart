// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:time_sort/api/videos.dart'; // Updated import based on the previous changes
import 'package:time_sort/models/video.dart';
import 'package:time_sort/pages/player.dart';

class VideosPage extends StatefulWidget {
  VideosPage({
    Key? key,
  }) : super(key: key);

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  ApiVideoService apiService = ApiVideoService();

  bool _isLoading = true; // Loading state
  List<Video> _videosList = [];

  @override
  void initState() {
    super.initState();
    _getVideos();
  }

  Future<void> _getVideos() async {
    try {
      _videosList = await apiService.fetchVideos();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'مشکلی در اتصال به اینترنت پیش آمده',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }
  }

  void _openVideo(Video video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _videosList.isEmpty
              ? Center(
                  child: Text(
                    'اطلاعاتی  برای نمایش وجود ندارد',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 24),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _videosList.length,
                  itemBuilder: (context, index) {
                    final video = _videosList[index];
                    return GestureDetector(
                      onTap: () => _openVideo(video),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        video.image,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    video.title,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
