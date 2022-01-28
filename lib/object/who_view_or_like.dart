import 'dart:async';
import 'dart:convert';
import '../path.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

Future<Views> whoViewOrlike(
    String postId, int whoLike, int whoView, int whoComment) async {
  final response =
      await http.post(Uri.parse('${AppPath.domain}/who_like_and _view.php'),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName('utf-8'),
          body: <String, dynamic>{
            "post_id": postId.toString(),
            "who_like": whoLike.toString(),
            "who_view": whoView.toString(),
            "who_comment": whoComment.toString()
          });

  print(response.body);

  if (response.statusCode == 200) {
    return Views.fromJson(json.decode(response.body));
  } else {
    throw Exception('Somethings went wrong, try again later.');
  }
}
