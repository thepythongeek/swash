import 'dart:convert';

import 'package:http/http.dart';
import 'package:swash/exceptions/network.dart';
import '../path.dart';

Future<String> addSchool(
    {required String name,
    required String phone,
    required String email,
    required String radius,
    required String addr,
    required String password,
    required String lattitude,
    required String longitude}) async {
  Response response =
      await post(Uri.parse("${AppPath.domain}/add_school.php"), body: {
    "name": name,
    "phone": phone,
    "email": email,
    "longitude": longitude,
    "lattitude": lattitude,
    "radius": radius,
    "password": password,
    "addr": addr
  });
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['status']) {
      return data['message'];
    }
    return Future.error(NetworkError(msg: data['message']));
  } else {
    return Future.error(NetworkError(msg: 'something went wrong'));
  }
}
