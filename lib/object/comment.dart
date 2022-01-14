import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentRequest {
  static const comment = 'http://trueapps.org/swash/apis/comment.php';
  static const postComment = 'http://trueapps.org/swash/apis/post_comment.php';

  Future<Comment> createPostComment(
      {required String userId,
      required String postID,
      required String comment}) async {
    final response = await http.post(
      Uri.parse(postComment),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(<String, String>{
        "user_id": userId,
        "comment": comment,
        "post_id": postID
      }),
    );

    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Comment.');
    }
  }
}

class Comment {
  final bool success;
  final String message;

  Comment({required this.success, required this.message});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(success: json['success'], message: json['message']);
  }
}
