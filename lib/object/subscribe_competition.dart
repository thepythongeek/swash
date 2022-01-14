import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<SubscribeCompetition> createSubscribeCompetition(String schoolId, String competitionId) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/subscribe_competition.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: {
      "school_id": schoolId,
      "competition_id": competitionId },
  );

  if (response.statusCode == 200) {
    return SubscribeCompetition.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load future subscribe competition');
  }
}

class SubscribeCompetition {

  final bool success;
  final bool isValid;

  SubscribeCompetition({ required this.success, required this.isValid });

  factory SubscribeCompetition.fromJson(Map<String, dynamic> json) {
    return SubscribeCompetition(
      success: json['success'], isValid: json['is_valid']);
  }
}