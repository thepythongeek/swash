import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/comment.dart';
import 'package:video_player/video_player.dart';
import '../../components/components.dart';
import '../../path.dart';

class SchoolForm extends StatefulWidget {
  final Posts post;
  static MaterialPage page(Posts post) {
    return MaterialPage(
        name: MyPages.schoolForm,
        key: const ValueKey(MyPages.schoolForm),
        child: SchoolForm(
          post: post,
        ));
  }

  const SchoolForm({Key? key, required this.post}) : super(key: key);

  @override
  State<SchoolForm> createState() => _SchoolFormState();
}

class _SchoolFormState extends State<SchoolForm> {
  final TextEditingController text = TextEditingController();
  VideoPlayerController? _controller;
  late Future<void> _playVideo;
  bool _replay = false;

  @override
  void dispose() {
    text.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.post.mediaType == 'video') {
      _playVideo = playVideo();
    }
    super.initState();
  }

  Future<void> playVideo() async {
    _controller = VideoPlayerController.network(
      widget.post.imageLink.startsWith('https')
          ? widget.post.imageLink
          : '${AppPath.domain}/${widget.post.imageLink}',
    );
    await _controller!.initialize();
    await _controller!.setVolume(1.0);
    await _controller!.setLooping(false);
    await _controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    List comments =
        Provider.of<CommentManager>(context, listen: false).comments;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          // main container to style the page
          child: ListView(
            // This column has two children a container containing an Icon button
            // and another container
            children: [
              GestureDetector(
                onTap: () {
                  print('89');
                  setState(() {
                    _replay = true;
                    _controller!.play();
                  });
                },
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: widget.post.mediaType == 'video' ||
                          widget.post.mediaType == 'video' && _replay
                      ? FutureBuilder(
                          future: _playVideo,
                          builder: (context, snapshot) {
                            print('**');
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('$snapshot.data'),
                                );
                              } else {
                                print('***');
                                print(_controller == null);
                                return AspectRatio(
                                    aspectRatio: 4 / 5,
                                    child: VideoPlayer(_controller!));
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                      : AspectRatio(
                          aspectRatio: 4 / 5,
                          child: Image.network(
                            widget.post.imageLink.startsWith('https')
                                ? widget.post.imageLink
                                : '${AppPath.domain}/${widget.post.imageLink}',
                            errorBuilder: (context, object, stacktrace) {
                              return const SizedBox(
                                child: Placeholder(),
                                height: 45,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        Provider.of<CommentManager>(context, listen: false).add(
                            widget.post.comments, widget.post.id.toString());
                        Provider.of<AppStateManager>(context, listen: false)
                            .toComments(true);
                      },
                      icon: const Icon(Icons.comment_rounded)),
                  Text(
                    '${widget.post.totalComments}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.fromLTRB(25, 2, 25, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // this column has a span of text then a container, more text
                  // and finally a textfield.
                  children: [
                    Text(widget.post.title),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          widget.post.content,
                          softWrap: true,
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
