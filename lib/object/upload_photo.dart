import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:swash/path.dart';

Future<String> createUploadPhoto(File image, String schoolId, String qnOneAns,
    String qnTwoAns, String competitionId) async {
  String base64 = base64Encode(image.readAsBytesSync());

  final response = await http.post(
    Uri.parse('${AppPath.domain}/upload_photo.php'),
    body: {
      "image": base64,
      "school_id": schoolId,
      "qn_one_ans": qnOneAns,
      "qn_two_ans": qnTwoAns,
      "competition_id": competitionId,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return json['message'];
  } else {
    throw Exception('Failed to create photo upload.');
  }
}

class UploadPhoto {
  final bool success;
  final String message;

  UploadPhoto({required this.success, required this.message});

  factory UploadPhoto.fromJson(Map<String, dynamic> json) {
    return UploadPhoto(success: json['success'], message: json['message']);
  }
}
