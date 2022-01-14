import 'dart:io';
import 'package:video_player/video_player.dart';

import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../path.dart';

class MediaPlayer extends StatefulWidget {
  final XFile? file;
  final bool isVideo;
  const MediaPlayer({Key? key, required this.file, this.isVideo = false})
      : super(key: key);

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return showMedia(isVideo: widget.isVideo, file: widget.file);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  Widget showMedia({
    XFile? file,
    required bool isVideo,
  }) {
    if (file != null && !isVideo) {
      return SizedBox(
        height: 150,
        child: Image.file(
          File(file.path),
          fit: BoxFit.contain,
        ),
      );
    } else if (file != null && isVideo) {
      return FutureBuilder(
          future: playVideo(file),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('$snapshot.data'),
                );
              } else {
                return AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    } else {
      return Container();
    }
  }

  Future playVideo(
    XFile? file,
  ) async {
    _controller = VideoPlayerController.file(File(file!.path));
    double volume = 1.0;
    await _controller!.initialize();
    await _controller!.setVolume(volume);

    await _controller!.setLooping(false);
    await _controller!.play();
  }
}
