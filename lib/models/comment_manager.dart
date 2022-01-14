import 'package:flutter/material.dart';

class CommentManager extends ChangeNotifier {
  List<Comment> _comments = [];
  String? _postId;
  List<Comment> get comments => _comments;
  String get postId => _postId!;

  void add(List<Comment> comments, String postId) {
    _comments = comments;
    _postId = postId;
    notifyListeners();
  }

  void reset() {
    _comments = [];
    _postId = null;
    notifyListeners();
  }
}

class Comment {
  final String author;
  final String review;
  final String createdAt;

  Comment(
      {required this.author, required this.createdAt, required this.review});

  factory Comment.fromJson(Map json) {
    return Comment(
        author: json['name'],
        createdAt: json['created_at'],
        review: json['review']);
  }
}
