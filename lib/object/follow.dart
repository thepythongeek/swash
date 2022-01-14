import 'package:http/http.dart';
import 'package:swash/path.dart';
import 'dart:convert';

Future<String> follow(
    {required String followedId,
    required String userId,
    bool follow = true}) async {
  Response response = await post(
      Uri.parse(follow
          ? '${AppPath.domain}/follow.php'
          : '${AppPath.domain}/unfollow.php'),
      body: {'userId': userId, 'followedId': followedId});
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  print(data);
  if (data['status']) {
    return data['message'];
  } else {
    return data['message'];
  }
}

Future<String> getFollowers({required String userId, followers = true}) async {
  Response response = await post(
      Uri.parse(followers
          ? '${AppPath.domain}/followers.php'
          : '${AppPath.domain}/following.php'),
      body: {"userId": userId});
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  print(data);
  if (data['status']) {
    return data['message']['followers'];
  } else {
    return data['message'];
  }
}
