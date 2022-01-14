import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Vote {
  final bool success;
  final String message;

  Vote({required this.success, required this.message});

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(success: json['success'], message: json['message']);
  }
}
