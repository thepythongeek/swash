import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/models.dart';

import 'comment_manager.dart';
import '../path.dart';

class GetPosts {
  bool success;
  List posts;

  GetPosts({required this.success, required this.posts});

  factory GetPosts.fromJson(
      {required Map<String, dynamic> json, BuildContext? context}) {
    List posts = [];
    for (var post in json['message']) {
      posts.add(Posts.fromJson(json: post, context: context!));
    }
    return GetPosts(success: json['success'], posts: posts);
  }
}

class Posts {
  int id;
  String name;
  String title;
  List<Comment> comments;
  String content;
  int totalLikes;
  int totalViews;
  String isExpert;
  String imageLink;
  String profilePic;
  String mediaType;
  int totalComments;
  String commentStatus;
  String isExpired;
  String priority;
  String? expiresIn;
  BuildContext? context;

  Posts(
      {required this.id,
      required this.isExpired,
      required this.priority,
      this.expiresIn,
      this.context,
      required this.name,
      required this.title,
      required this.comments,
      required this.content,
      required this.totalLikes,
      required this.totalViews,
      required this.isExpert,
      required this.imageLink,
      required this.profilePic,
      required this.totalComments,
      required this.mediaType,
      required this.commentStatus}) {
    if (context != null) {
      timer(context!);
    }
  }

  factory Posts.fromJson(
      {required Map<String, dynamic> json, BuildContext? context}) {
    List<Comment> comments = [];
    if (json['comments'] != null) {
      for (var i in json['comments']) {
        comments.add(Comment.fromJson(i));
      }
    }

    var post = Posts(
        id: int.parse(json['id']),
        context: context,
        name: json['name'],
        title: json['title'],
        comments: comments,
        content: json['content'],
        totalLikes: int.parse(json['total_likes']),
        totalViews: int.parse(json['total_views']),
        isExpert: json['is_expert'],
        imageLink: json['image_link'],
        profilePic: json['profile_pic'] ?? '',
        totalComments: int.parse(json['total_comments']),
        commentStatus: json['comment_status'],
        priority: json['priority'],
        isExpired: json['isExpired'],
        expiresIn: json['expiresIn'],
        mediaType: json['media_type']);
    post.timer(context!);
    return post;
  }

  void timer(BuildContext context) {
    // check whether a post is set to expire and start a timer
    // after which update the post in the database

    // has the post expired?
    // has the expiration duration set if post has not expired
    if (isExpired == '0' && expiresIn != null) {
      Timer(Duration(minutes: int.parse(expiresIn!)), () {
        update().then((value) {
          Provider.of<Postmanager>(context, listen: false).addFreshPost(
              id: id,
              name: name,
              title: title,
              comments: comments,
              content: content,
              totalLikes: totalLikes,
              totalViews: totalViews,
              isExpert: isExpert,
              imageLink: imageLink,
              profilePic: profilePic,
              mediaType: mediaType,
              totalComments: totalComments,
              commentStatus: commentStatus,
              priority: priority,
              expiresIn: expiresIn,
              isExpired: isExpired);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('post removed successfully')));
        }).catchError((error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$error')));
        }, test: (error) => error is NetworkError);
      });
    }
  }

  @override
  String toString() {
    return '$id,$content';
  }

  Future<Posts> update() async {
    Response response = await post(
        Uri.parse('${AppPath.domain}/update_post.php'),
        body: {'id': id.toString()});
    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status']) {
        return Posts.fromJson(json: data['message'], context: context);
      } else {
        return Future.error(NetworkError(msg: data['message']));
      }
    } else {
      return Future.error(NetworkError(msg: 'something went wrong'));
    }
  }
}
