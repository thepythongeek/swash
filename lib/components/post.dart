import 'package:video_player/video_player.dart';

import '../path.dart';
import 'components.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../object/who_view_or_like.dart';
import 'package:swash/models/models.dart' as models;
import 'package:focus_detector/focus_detector.dart';

class Post extends StatefulWidget {
  final models.Posts post;
  const Post({Key? key, required this.post}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _comment = false;
  VideoPlayerController? _controller;
  bool _play = true;
  bool _pause = false;
  late Future<void> _playVideo;

  // a state to determine whether the user has viewed post
  bool _viewed = false;

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileManager _profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    final AppStateManager _appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final Postmanager postmanager =
        Provider.of<Postmanager>(context, listen: false);
    print(widget.post);

    return FocusDetector(
        onVisibilityGained: () {
          if (!_viewed) {
            whoViewOrlike(widget.post.id.toString(), 0, 1, 0);
            _viewed = true;
          }

          /* setState(() {
            _play = true;
            _controller!.play();
          });*/
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    print('|||***');
                    print(_profileManager.user!.role);
                    print(_appStateManager.navigation.schoolForm);
                    // add the post model
                    postmanager.addPost(
                        totalComments: widget.post.totalComments,
                        isExpired: widget.post.isExpert,
                        priority: widget.post.priority,
                        expiresIn: widget.post.expiresIn,
                        commentStatus: widget.post.commentStatus,
                        totalViews: widget.post.totalViews,
                        isExpert: widget.post.isExpert,
                        mediaType: widget.post.mediaType,
                        name: widget.post.name,
                        totalLikes: widget.post.totalLikes,
                        id: widget.post.id,
                        content: widget.post.content,
                        title: widget.post.title,
                        imageLink: widget.post.imageLink,
                        profilePic: widget.post.profilePic,
                        comments: widget.post.comments);
                    _appStateManager.goto(MyPages.schoolForm, true);
                  },
                  child: Row(
                    children: [
                      // a column and an image
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('written by'),
                          FittedBox(
                            child: profileRow(
                                path: widget.post.profilePic,
                                name: widget.post.name,
                                isverified: widget.post.isExpert),
                          ),
                          Text(
                            widget.post.title,
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.post.content,
                            softWrap: true,
                          )
                        ],
                      )),
                      Expanded(
                          child: ClipRRect(
                        child: widget.post.mediaType == 'video' //&& _play
                            ? MediaPlayer(fileUrl: widget.post.imageLink)
                            : Image.network(
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
                      ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PostButton(
                        views: Views(
                            comments: widget.post.totalComments,
                            likes: widget.post.totalLikes,
                            views: widget.post.totalViews),
                        name: 'comment',
                        turn: turnComment,
                        postID: widget.post.id.toString()),
                    PostButton(
                      name: 'like',
                      postID: widget.post.id.toString(),
                      views: Views(
                          comments: widget.post.totalComments,
                          likes: widget.post.totalLikes,
                          views: widget.post.totalViews),
                    ),
                    Row(
                      children: [
                        const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.error_outline_outlined)),
                        const SizedBox(
                          width: 8,
                        ),
                        Text('${widget.post.totalViews}')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void turnComment() {
    Provider.of<CommentManager>(context, listen: false)
        .add(widget.post.comments, widget.post.id.toString());
    print(Provider.of<CommentManager>(context, listen: false).postId);
    Provider.of<AppStateManager>(context, listen: false).toComments(true);
  }
}

class MediaPlayer extends StatefulWidget {
  final String fileUrl;
  const MediaPlayer({Key? key, required this.fileUrl}) : super(key: key);

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  VideoPlayerController? _controller;
  bool _play = true;
  late Future<void> _playVideo;

  @override
  void initState() {
    _playVideo = playVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _playVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('$snapshot.data'),
              );
            } else {
              return Stack(children: [
                AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!)),
                Positioned(
                    top: 100,
                    left: 50,
                    child: IconButton(
                        color: Colors.amber,
                        iconSize: 50,
                        onPressed: () {
                          setState(() {
                            _controller!.play();
                            _play = false;
                          });
                        },
                        icon: Icon(_play ? Icons.play_arrow : Icons.pause)))
              ]);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> playVideo() async {
    _controller = VideoPlayerController.network(
      widget.fileUrl.startsWith('https')
          ? widget.fileUrl
          : '${AppPath.domain}/${widget.fileUrl}',
    );
    await _controller!.initialize();
    await _controller!.setVolume(1.0);
    await _controller!.setLooping(false);
    //await _controller!.play();
    // add a listener
    _controller!.addListener(() {
      VideoPlayerValue value = _controller!.value;
      if (!value.isPlaying) {
        setState(() {
          _play = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
