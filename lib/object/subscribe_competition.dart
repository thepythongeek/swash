import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swash/exceptions/network.dart';
import 'package:swash/path.dart';

Future<bool> subscribeCompetition(String schoolId, String competitionId) async {
  final response = await http.post(
    Uri.parse(AppPath.domain + '/subscribe_competition.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {"school_id": schoolId, "competition_id": competitionId},
  );
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['success']) {
      return data['is_valid'];
    } else {
      return data['is_valid'];
    }
  } else {
    return Future.error(NetworkError(msg: 'failed to subscribe'));
  }
}
