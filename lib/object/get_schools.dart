import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<GetSchools> fetchGetSchools() async {
  final response = await http
      .get(Uri.parse('http://trueapps.org/swash/apis/get_schools.php'));

  if (response.statusCode == 200) {
    return GetSchools.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load get schools');
  }
}

class GetSchools {

  final String success;
  final String schools;
  final String message;

  GetSchools({ required this.success, required this.schools, required this.message });

  factory GetSchools.fromJson(Map<String, dynamic> json) {
    return GetSchools(
      success: json['success'],
      schools: json['schools'],
      message: json['message'],
    );
  }
}