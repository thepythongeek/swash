import 'dart:async';
import 'dart:convert';
import '../path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:swash/models/models.dart';
import 'package:swash/models/themes.dart';
import 'package:swash/object/get_themes.dart';
import 'package:swash/Screens/voter/addevent.dart';
import 'package:swash/components/post.dart' as component;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

Future<GetPosts> getPosts(BuildContext context,
    {String next = "null",
    String startId = "null",
    String lastId = "null"}) async {
  final response = await http.post(Uri.parse('${AppPath.domain}/get_posts.php'),
      body: {"next": next, "start_id": startId, "last_id": lastId});

  print(response.body);

  if (response.statusCode == 200) {
    return GetPosts.fromJson(
        json: json.decode(response.body), context: context);
  } else {
    throw Exception('Failed to load posts.');
  }
}

Future<GetThemes> getThemes(String type) async {
  final response = await http.post(
      Uri.parse("${AppPath.domain}/get_themes.php"),
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName('utf-8'),
      body: {"competition_type": type});
  if (response.statusCode == 200) {
    return GetThemes.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load themes.');
  }
}

class Updates extends StatefulWidget {
  const Updates({Key? key}) : super(key: key);
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  List posts = [];
  String? startId;
  String? lastId;
  late Future<GetPosts> _getPosts;
  late Future<GetThemes> _listOfThemes;
  ScrollController _controller = ScrollController();
  final PagingController _pagingController =
      PagingController<String, Posts>(firstPageKey: "null");

  void _scrollListener() {
    Postmanager postmanager = Provider.of<Postmanager>(context, listen: false);
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // getPosts(context,
      //     startId: startId ?? "null", lastId: lastId!, next: "true");
      //  postmanager.loadPosts();
      getPosts(context,
              startId: startId ?? "null", lastId: lastId!, next: "true")
          .then((value) {
        postmanager.addMorePosts(value);
        postmanager.loadPosts();
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      getPosts(context,
              startId: startId ?? "null", lastId: lastId!, next: "false")
          .then((value) {
        postmanager.addMorePosts(value);
        postmanager.loadPosts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    //_getPosts = getPosts(context);
    //  getPosts(context, startId: "6", lastId: "1", next: "true");
    _listOfThemes = getThemes('all');
    _pagingController.addPageRequestListener((pageKey) {
      retrievePosts(pageKey);
    });
  }

  Future<void> retrievePosts(String pageKey) async {
    GetPosts value;
    try {
      if (pageKey == "null") {
        value = await getPosts(context);
      } else {
        value = await getPosts(context, next: "true", lastId: pageKey);
      }
      _pagingController.appendPage(value.posts, value.lastId);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Provider.of<AppStateManager>(context, listen: false)
                .goto(MyPages.eventform, true);
          },
        ),
        body: RefreshIndicator(
            child: PagedListView.separated(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Posts>(
                  itemBuilder: (context, posts, index) {
                    print(posts);
                    return component.Post(
                      post: posts,
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) =>
                      Center(child: Text('${_pagingController.error}')),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CircularProgressIndicator(),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    )),
            onRefresh: () => Future.sync(() => _pagingController.refresh())));
    /* FutureBuilder<GetPosts>(
            future: _getPosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  posts = snapshot.data!.posts;
                  if (posts.isNotEmpty) {
                    print(snapshot.data!.startId);
                    startId = snapshot.data!.startId;
                    lastId = snapshot.data!.lastId;
                  }
                  return ListView(controller: _controller, children: [
                    if (posts.isEmpty)
                      availableCompetition(appStateManager, themeManager),
                    if (posts.isNotEmpty)
                      const ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          'Current Updates',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    if (posts.isNotEmpty)
                      Consumer<Postmanager>(builder: (context, value, child) {
                        if (value.onUpdate) {
                          posts = posts
                              .where((element) =>
                                  element.id != value.getFreshPost.id)
                              .toList();

                          posts.add(value.getFreshPost);
                          //posts.add(value.getFreshPost);
                          //value.resetUpdateEvent();
                          return component.Post(post: posts[0]);
                        } else {
                          return component.Post(post: posts[0]);
                        }
                      }),
                    if (posts.isNotEmpty)
                      availableCompetition(appStateManager, themeManager),
                    if (posts.isNotEmpty)
                      Container(
                        child: const ListTile(
                          title: Text('Other Updates'),
                          tileColor: Colors.white,
                        ),
                      ),
                    if (posts.isNotEmpty)
                      Consumer<Postmanager>(builder: (context, value, child) {
                        if (value.onUpdate) {
                          value.resetUpdateEvent();
                        }
                        if (value.morePosts) {
                          List _posts = value.posts.posts;
                          startId = value.posts.startId;
                          lastId = value.posts.lastId;
                          // allow our app to have maximum of 12 posts
                          // at any moment. If there are more
                          // discard old posts entirely
                          if (posts.length == 12) {
                            posts = _posts;
                          } else {
                            posts.addAll(_posts);
                          }
                          value.resetMorepostsEvent();
                        }

                        /* return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return component.Post(post: posts[index + 1]);
                          },
                          itemCount: posts.length - 1,
                        );*/
                        
                      })
                  ]);
                } else {
                  return const Center(
                    child: Text('Something went wrong please come back again'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));*/
  }

  Card availableCompetition(
      AppStateManager appStateManager, ThemeManager themeManager) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Column(
        children: [
          Container(
            child: const ListTile(
              title: Text('Available Competitions'),
              tileColor: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: FutureBuilder<GetThemes>(
              future: _listOfThemes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> children = [];
                  var data = snapshot.data!.themes;
                  if (data.isEmpty) {
                    const Text('Data not found.');
                  } else {
                    for (int i = 0; i < data.length; i++) {
                      children.add(
                          thmesInfo(data[i], appStateManager, themeManager));
                    }
                  }
                  return Column(children: children);
                } else {
                  return const Text('Data not found.');
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget thmesInfo(
      Map theme, AppStateManager appStateManager, ThemeManager themeManager) {
    return ListTile(
      tileColor: Colors.white,
      title: Text('${theme['title']}'),
      subtitle: Text('${theme['theme']}'),
      trailing: TextButton(
        onPressed: () {
          // add theme
          themeManager.addTheme(Themes.fromMap(theme));
          print(111);
          appStateManager.goto(MyPages.challenge, true);
        },
        child: Text(
          '${theme['status']}',
          style: const TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(12.0, 12.0)))),
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
      ),
    );
  }
}
