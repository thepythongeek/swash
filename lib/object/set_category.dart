import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<SetCategory> createSetCategory(String userId, String action, String categoryId) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/set_category.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: {
      "action": action,
      "user_id": userId, "category_id": categoryId }
  );

  if (response.statusCode == 201) {
    return SetCategory.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create set category.');
  }
}

class SetCategory {

  final bool success;
  final String message;

  SetCategory({required this.success, required this.message});

  factory SetCategory.fromJson(Map<String, dynamic> json) {
    return SetCategory(
      success: json['success'], message: json['message']);
  }
}