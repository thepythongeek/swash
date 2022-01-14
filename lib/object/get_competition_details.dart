import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swash/path.dart';
import '../models/models.dart';

Future<GetCompetitionDetails> getCompetitionDetails(
    String competitionId, String schoolId) async {
  final response = await http
      .post(Uri.parse('${AppPath.domain}/get_competition_details.php'), body: {
    "competition_id": competitionId,
    "school_id": schoolId,
  });
  print(response.body);
  if (response.statusCode == 200) {
    return GetCompetitionDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create get competition details.');
  }
}
