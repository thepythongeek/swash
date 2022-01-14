import 'dart:convert';

import 'package:http/http.dart';
import 'package:swash/exceptions/network.dart';
import '../path.dart';

Future<String> findFirstVoter(
    {required String userId, required String competitionId}) async {
  Response response = await post(
      Uri.parse('${AppPath.domain}/find_top_voter.php'),
      body: {"id": userId, "competition_id": competitionId});

  print(response.body);

  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['status']) {
      return data['message'];
    } else {
      return data['message'];
    }
  } else {
    return Future.error(NetworkError(msg: 'something is wrong'));
  }
}
