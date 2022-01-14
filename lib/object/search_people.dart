import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../path.dart';
import '../models/models.dart';

Future<People> createSearchPeople(String keyword, String userId) async {
  final response = await http.post(
      Uri.parse('${AppPath.domain}/search_people.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName('utf-8'),
      body: {"keyword": keyword, "userId": userId});

  if (response.statusCode == 200) {
    return People.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create set search people.');
  }
}
