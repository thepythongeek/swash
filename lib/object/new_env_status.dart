import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../path.dart';
import 'package:http_parser/http_parser.dart';

Future createNewEnvStatus(
    {required Map image,
    required String status,
    required String userId,
    String latitude = '45.7',
    String longitude = '-78',
    required String description,
    required String locationName}) async {
  var uri = Uri.parse('${AppPath.domain}/new_env_status.php');
  File file = image['image'];
  String s = base64Encode(file.readAsBytesSync());

  http.Response response = await http.post(uri, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }, body: {
    'status': status,
    'user_id': userId,
    'latitude': latitude,
    'longitude': longitude,
    'location_name': locationName,
    'description': description,
    'image': s
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to create post comment.');
  }
}
