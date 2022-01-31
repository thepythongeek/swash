import 'dart:async';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/find_top_voter.dart';
import 'package:swash/path.dart';
import 'package:swash/toasty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:web_socket_channel/io.dart';

Future<dynamic> getImagesToVote(String? userId) async {
  final response = await http.post(
    Uri.parse('${AppPath.domain}/get_images_to_vote.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {'user_id': userId},
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return Toasty().show(
        'Somethings went wrong.', Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}

Future<dynamic> createVote(String vote, String? userId, String imageId) async {
  final response = await http.post(Uri.parse('${AppPath.api}/vote.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName('utf-8'),
      body: {"vote": vote, "user_id": userId, "image_id": imageId});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return Toasty().show(
        'Somethings went wrong.', Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}

Future<dynamic> postComment(
    String? userId, String comment, String imageId) async {
  final response = await http.post(
    Uri.parse('${AppPath.api}/comment.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {"user_id": userId, "comment": comment, "image_id": imageId},
  );
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return Toasty().show(
        'Somethings went wrong.', Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}

Future<dynamic> getImageComments(String imageId) async {
  final response = await http.post(
    Uri.parse('${AppPath.api}/get_comments.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {"image_id": imageId},
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return Toasty().show(
        'Somethings went wrong.', Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}

class VotePage extends StatefulWidget {
  final CarouselController buttonCarouselController = CarouselController();

  VotePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  int _index = 0;

  Path path = Path();
  late Future<dynamic> _imagesToVote;

  late bool _voted;
  late String _imageId;

  var count = 0;
  List _imageList = [];
  var _listOfComments = [];
  String competitionId = "";
  String competitionTheme = "";

  @override
  void initState() {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    _imagesToVote = getImagesToVote(profileManager.user!.id);
    super.initState();
  }

  Future<List> getComments(String imageId) async {
    Map<String, dynamic> comments = await getImageComments(imageId);
    return comments['comments'];
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    getImageComments(_imageList[index]['id']).then((value) {
      setState(() {
        _voted = _imageList[index]['voted'];
        _imageId = _imageList[index]['id'];
        _listOfComments = value['comments'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    final TextEditingController userComment = TextEditingController();

    return FutureBuilder<dynamic>(
      future: _imagesToVote,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            competitionId = data['competition_id'];
            _imageList = snapshot.data!['images'];

            if (_imageList.isEmpty) {
              return const Center(
                child: Text('No data for now to vote'),
              );
            }
            return ListView(children: [
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                    data['competition_caption'] +
                                        ' ${_imageList[_index]['qns_one']}, ${_imageList[_index]['qn_two']}',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 18))),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: CarouselSlider.builder(
                                itemCount: _imageList.length,
                                options: CarouselOptions(
                                  autoPlay: false,
                                  onPageChanged: onPageChange,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  aspectRatio: 4 / 5,
                                ),
                                carouselController:
                                    widget.buttonCarouselController,
                                itemBuilder: (context, index, realIdx) {
                                  _index = index;

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: CachedNetworkImage(
                                          memCacheHeight: 400,
                                          imageUrl:
                                              '${AppPath.domain}/${_imageList[index]['url']}',
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                ),
                                                const Text('Loading Image...')
                                              ],
                                            );
                                          },
                                          fit: BoxFit.cover,
                                          errorWidget:
                                              (context, object, stacktrace) {
                                            return const Icon(Icons.error);
                                          },
                                          width: 1000),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              data['competition_name'] + '?',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              '${_index + 1} of ${_imageList.length} images',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Voting(
                                competitionId: competitionId,
                                imageId: _imageList[_index]['id'],
                                carouselController:
                                    widget.buttonCarouselController,
                              ),
                            )
                          ]))),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(width: .24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COMMENTS',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 5)),
                      TextFormField(
                        controller: userComment,
                        decoration: InputDecoration(
                          labelText: "Enter your comment here",
                          suffixIcon: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // added line
                            mainAxisSize: MainAxisSize.min, // added line
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  (userComment.text == "")
                                      ? Toasty().show(
                                          'Empty comment is not allowed.',
                                          Toast.LENGTH_SHORT,
                                          ToastGravity.BOTTOM)
                                      : postComment(profileManager.user!.id,
                                              userComment.text, _imageId)
                                          .then((value) {
                                          userComment.text = "";
                                          Toasty().show(
                                              value['message'],
                                              Toast.LENGTH_SHORT,
                                              ToastGravity.BOTTOM);
                                        });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //
                      const Padding(padding: EdgeInsets.only(bottom: 5)),

                      FutureBuilder<List>(
                          future: getComments(_imageList[_index]['id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Oops something went wrong'));
                              }
                              var data = snapshot.data;
                              return ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(data[index]['name']),
                                      subtitle: Text(data[index]['review']),
                                      trailing: Text(data[index]['created_at']),
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                    ],
                  ))
            ]);
          } else {
            return const Center(
              child: Text('Something went wrong please try again later'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Voting extends StatefulWidget {
  final String imageId;
  final String competitionId;
  final CarouselController carouselController;
  const Voting(
      {Key? key,
      required this.imageId,
      required this.competitionId,
      required this.carouselController})
      : super(key: key);

  @override
  _VotingState createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  bool vote = false;
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    IOWebSocketChannel channel =
        Provider.of<AppStateManager>(context, listen: false).channel!;
    return !vote
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 100.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(12.0, 12.0))),
                  child: IconButton(
                    onPressed: () {
                      widget.carouselController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    icon: const Icon(Icons.skip_previous),
                  )),
              TextButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(30)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all(const CircleBorder())),
                  onPressed: () {
                    setState(() {
                      vote = !vote;
                    });
                  },
                  child: const Text(
                    'Vote',
                    style: TextStyle(color: Colors.white),
                  )),
              Container(
                  width: 100.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(12.0, 12.0))),
                  child: IconButton(
                    onPressed: () {
                      widget.carouselController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    icon: const Icon(Icons.skip_next),
                  ))
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Slider(
                    label: '${value.round()}%',
                    divisions: 100,
                    max: 100,
                    value: value,
                    onChanged: (double newvalue) {
                      setState(() {
                        value = newvalue;
                      });
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (vote) {
                      createVote(
                              value.toString(),
                              Provider.of<ProfileManager>(context,
                                      listen: false)
                                  .user!
                                  .id,
                              widget.imageId)
                          .then((value) {
                        Toasty().show('${value['message']}', Toast.LENGTH_SHORT,
                            ToastGravity.BOTTOM);
                        widget.carouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                        findFirstVoter(
                                userId: profileManager.user!.id,
                                competitionId: widget.competitionId)
                            .then((value) {
                          Toasty()
                              .show(value, Toast.LENGTH_LONG, ToastGravity.TOP);
                          channel.sink.add(
                              jsonEncode({"event": "prize", "message": value}));
                        });
                      });
                      setState(() {
                        vote = false;
                      });
                    }
                  },
                  child: const Text('submit'))
            ],
          );
  }
}
