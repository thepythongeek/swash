import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../path.dart';

Future<TopVoters> getTopVoters(String compId) async {
  final response = await http.post(
    Uri.parse('${AppPath.domain}/get_top_voters.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {"comp_id": compId},
  );
  if (response.statusCode == 200) {
    return TopVoters.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post comment.');
  }
}
