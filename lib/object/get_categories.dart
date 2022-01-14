import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<GetCategories> fetchGetCategories() async {
  final response = await http
      .get(Uri.parse('http://trueapps.org/swash/apis/get_categories.php'));

  if (response.statusCode == 200) {
    return GetCategories.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load get categories');
  }
}

class GetCategories {

  final String message;
  final String success;
  final String categories; // array

  GetCategories({
    required this.message,
    required this.success,
    required this.categories,
  });

  factory GetCategories.fromJson(Map<String, dynamic> json) {
    return GetCategories(
      message: json['message'],
      success: json['success'],
      categories: json['categories']
    );
  }
}