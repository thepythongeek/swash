import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';
import 'posts.dart';

class Postmanager extends ChangeNotifier {
  Posts? _post;
  Posts? _freshPost;
  bool _onUpdate = false;
  bool _isViewed = false;
  bool _isLiked = false;

  Posts get getPost => _post!;
  Posts get getFreshPost => _freshPost!;
  bool get isViewed => _isViewed;
  bool get onUpdate => _onUpdate;

  void addPost(
      {required int id,
      required String name,
      required String title,
      required List<Comment> comments,
      required String content,
      required int totalLikes,
      required int totalViews,
      required String isExpert,
      required String imageLink,
      required String profilePic,
      required String mediaType,
      required int totalComments,
      required String commentStatus,
      required String priority,
      String? expiresIn,
      required String isExpired}) {
    _post = Posts(
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
        totalComments: totalComments,
        commentStatus: commentStatus,
        expiresIn: expiresIn,
        isExpired: isExpired,
        priority: priority,
        mediaType: mediaType);
  }

  void addFreshPost(
      {required int id,
      required String name,
      required String title,
      required List<Comment> comments,
      required String content,
      required int totalLikes,
      required int totalViews,
      required String isExpert,
      required String imageLink,
      required String profilePic,
      required String mediaType,
      required int totalComments,
      required String commentStatus,
      required String priority,
      String? expiresIn,
      required String isExpired}) {
    _freshPost = Posts(
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
        totalComments: totalComments,
        commentStatus: commentStatus,
        expiresIn: expiresIn,
        isExpired: isExpired,
        priority: priority,
        mediaType: mediaType);
    _onUpdate = true;
    notifyListeners();
  }

  void resetUpdateEvent() {
    _onUpdate = false;
  }
}

/*class Post {
  String id;
  String content;
  String title;
  String image;
  String profilePic;
  List comments;

  Post(
      {required this.content,
      required this.id,
      required this.image,
      required this.title,
      required this.profilePic,
      required this.comments});
}*/

//SELECT COUNT(user_id) FROM `likes`  post_id WHERE liked=1 AND post_id=5 GROUP BY post_id;