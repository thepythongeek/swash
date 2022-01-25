import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/components.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/get_post_comments.dart';
import 'package:swash/object/send_comment.dart';
import '../path.dart';

class DraggableComments extends StatefulWidget {
  final String postId;
  const DraggableComments({Key? key, required this.postId}) : super(key: key);

  static MaterialPage page(String postId) {
    print('in page callable');
    print(postId);
    return MaterialPage(
        name: MyPages.comments,
        key: const ValueKey(MyPages.comments),
        child: DraggableComments(
          postId: postId,
        ));
  }

  @override
  _DraggableCommentsState createState() => _DraggableCommentsState();
}

class _DraggableCommentsState extends State<DraggableComments> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<Comment> comments;
  List<Comment> more = [];

  @override
  void initState() {
    comments = Provider.of<CommentManager>(context, listen: false).comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.postId);
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    CommentManager commentManager =
        Provider.of<CommentManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            commentManager.reset();
            Provider.of<AppStateManager>(context, listen: false)
                .goto(MyPages.comments, false);
          },
        ),
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Stack(children: [
        ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comments[index].author),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${processDate(comments[index].createdAt)}')
                  ],
                ),
                subtitle: Text(comments[index].review),
              );
            }),
        Positioned(
            bottom: 0,
            height: 70,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              // color: Colors.amber,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  createProfile(
                      path: profileManager.user!.profile!.profilePic,
                      radius: 50),
                  /*CircleAvatar(
                      radius: 50,
                      child: profileManager.user.profile != null &&
                              profileManager.user.profile!.profilePic != null
                          ? Image.network(
                              profileManager.user.profile!.profilePic!
                                      .startsWith('https')
                                  ? profileManager.user.profile!.profilePic!
                                  : '${AppPath.domain}${profileManager.user.profile!.profilePic!}',
                              errorBuilder: (context, object, stacktrace) {
                                print(profileManager.user.profile!.profilePic);
                                return const Icon(
                                  Icons.person,
                                  size: 60,
                                );
                              },
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                            )),*/
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        hintText: 'Add comment',
                        filled: true,
                        fillColor: Colors.amber,
                        suffixIcon: TextButton(
                            onPressed: () {
                              if (_textEditingController.text.isNotEmpty) {
                                // post comment
                                sendComment(
                                        userID: profileManager.user!.id,
                                        postID: widget.postId,
                                        content: _textEditingController.text)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                  // try fetching comments from server
                                  getPostComments(postId: widget.postId)
                                      .then((value) {
                                    // compare old comments list with fresh one
                                    List<Comment> fresh = [];
                                    for (Comment comment in value) {
                                      if (!comments.contains(comment)) {
                                        fresh.add(comment);
                                      }
                                    }
                                    fresh.sort((x, y) =>
                                        DateTime.parse(x.createdAt).compareTo(
                                            DateTime.parse(y.createdAt)));
                                    fresh = fresh.reversed.toList();
                                    setState(() {
                                      comments = fresh;
                                    });
                                  }).catchError(
                                    (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text('$e')));
                                    },
                                    test: (error) => error is NetworkError,
                                  );
                                });
                              }
                            },
                            child: const Text('Post')),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ))
      ]),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

Object processDate(String dateString) {
  Map months = {
    1: 'Jan',
    2: 'Feb',
    3: 'March',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'July',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };
  // parse string to date
  DateTime date = DateTime.parse(dateString);

  return '${date.day} ${months[date.month]}';
}
