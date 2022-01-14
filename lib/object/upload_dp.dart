import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../path.dart';

Future<UploadDp> createUploadDp(String userId, String profilePhoto) async {
  final response = await http.post(
    Uri.parse('${AppPath.domain}/upload_dp.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {
      "user_id": userId,
      "profile_photo": profilePhoto,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return UploadDp.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create upload dp.');
  }
}

class UploadDp {
  final bool success;
  final String message;

  UploadDp({required this.success, required this.message});

  factory UploadDp.fromJson(Map<String, dynamic> json) {
    return UploadDp(success: json['success'], message: json['message']);
  }
}
