import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<SecurityCodeCheck> createSecurityCodeCheck(String userId, String securityCode) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/security_code_check.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: { "user_id": userId, "security_code": securityCode },
  );

  if (response.statusCode == 201) {
    return SecurityCodeCheck.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create set category.');
  }
}

class SecurityCodeCheck {

  final bool success;
  final String message;

  SecurityCodeCheck({required this.success, required this.message});

  factory SecurityCodeCheck.fromJson(Map<String, dynamic> json) {
    return SecurityCodeCheck(
      success: json['success'], message: json['message']);
  }
}