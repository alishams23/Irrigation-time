import 'package:flutter/material.dart';

import 'package:time_sort/models/video.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {
  final Video video;

  PlayerPage({super.key, required this.video});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _loading = true;
  @override
  void initState() {
    initialPlayer();
    super.initState();
  }

  void initialPlayer() async {
    _loading = true;
    String url = widget.video.video!.path;

    if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "https://");
    }
    _videoPlayerController = await VideoPlayerController.networkUrl(Uri.parse(url));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    _videoPlayerController.initialize().then((value) {
      setState(() {
        _videoPlayerController.play();
      });
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: _loading == false
          ? Center(
              child: Chewie(
                controller: _chewieController,
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
