import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CheckActiveCompetitions> fetchCheckActiveCompetitions() async {
  final response = await http
      .get(Uri.parse('http://trueapps.org/swash/apis/check_active_competitions.php'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CheckActiveCompetitions.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load check active check active competitions');
  }
}

class CheckActiveCompetitions {

  final bool success;
  final String message;
  final String activeCompetitions;

  CheckActiveCompetitions({
    required this.success,
    required this.message,
    required this.activeCompetitions,
  });

  factory CheckActiveCompetitions.fromJson(Map<String, dynamic> json) {
    return CheckActiveCompetitions(
      success: json['success'],
      message: json['message'],
      activeCompetitions: json['active_competitions'],
    );
  }
}