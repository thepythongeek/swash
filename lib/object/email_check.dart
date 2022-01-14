import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<EmailCheck> createEmailCheck(String email, String securityCode) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/email_check.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: jsonEncode(<String, String>{
      "email": email,
      "security_code": securityCode
    }),
  );

  if (response.statusCode == 201) {
    return EmailCheck.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create email check.');
  }
}

class EmailCheck {

  final bool success;
  final String userId;
  final String roleId;
  final String message;
  final String schoolId;

  EmailCheck({
    required this.success, required this.userId,
    required this.message, required this.roleId, required this.schoolId  });

  factory EmailCheck.fromJson(Map<String, dynamic> json) {
    return EmailCheck(
      userId: json['user_id'],
      roleId: json['role_id'],
      success: json['success'],
      message: json['message'],
      schoolId: json['school_id'],
    );
  }
}