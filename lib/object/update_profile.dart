import 'dart:convert';

import 'package:http/http.dart' as http;
import '../path.dart';

Future<String> updateProfile(
    {required String location,
    required String profession,
    required String bio,
    required String userId,
    required String dob}) async {
  http.Response response =
      await http.post(Uri.parse('${AppPath.domain}/updateProfile.php'), body: {
    "location": location,
    "dob": dob,
    "profession": profession,
    "bio": bio,
    "user_id": userId
  });
  print(dob);
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['status']) {
    return data['message'];
  } else {
    return data['message'];
  }
}
