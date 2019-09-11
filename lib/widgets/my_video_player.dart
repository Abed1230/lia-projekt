import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  MyVideoPlayer(this._url);

  final String _url;

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget._url);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: false,
      autoInitialize: true,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              MyStrings.videoPlayerErrorMsg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
