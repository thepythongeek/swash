import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/models.dart';
import '../path.dart';

Future<List<Comment>> getPostComments({required String postId}) async {
  http.Response response = await http.post(
      Uri.parse('${AppPath.domain}/get_post_comments.php'),
      body: {'post_id': postId});

  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['success']) {
    List<Comment> comments = [];
    for (Map i in data['message']) {
      comments.add(Comment.fromJson(i));
    }
    return comments;
  } else {
    throw NetworkError(msg: data['message']);
  }
}
