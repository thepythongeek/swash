import '../models/models.dart';
import '../path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../toasty.dart';

Future<GetProfile> getProfile(String? userId, String followingId) async {
  final response = await http.post(
    Uri.parse('${AppPath.domain}/get_profile.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {'user_id': userId, "followingId": followingId},
  );
  print(followingId);
  print(response.body);
  if (response.statusCode == 200) {
    return GetProfile.fromJson(json.decode(response.body));
  } else {
    return Toasty().show(
        'Somethings went wrong.', Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}
