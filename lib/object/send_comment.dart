import 'dart:convert';

import 'package:http/http.dart' as http;
import '../path.dart';

Future<String> sendComment(
    {required String userID,
    required String postID,
    required String content}) async {
  http.Response response = await http.post(
      Uri.parse('${AppPath.domain}/send_post_comment.php'),
      body: {'user_id': userID, 'post_id': postID, 'content': content});

  print(response);
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['success']) {
    return data['message'];
  } else {
    return data['message'];
  }
}
