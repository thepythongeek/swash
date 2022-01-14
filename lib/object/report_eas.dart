import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ReportEas> createReportEas(String alertId) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/report_eas.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: { "alert_id": alertId },
  );

  if (response.statusCode == 201) {
    return ReportEas.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create report eas.');
  }
}

class ReportEas {
  final bool success;
  final String message;

  ReportEas({required this.success, required this.message});

  factory ReportEas.fromJson(Map<String, dynamic> json) {
    return ReportEas(
      success: json['success'], message: json['message']);
  }
}