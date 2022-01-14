import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<GetAllWards> fetchGetAllWards() async {
  final response = await http
      .get(Uri.parse('http://trueapps.org/swash/apis/get_all_wards.php'));

  if (response.statusCode == 200) {
    return GetAllWards.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load get allWards');
  }
}

class GetAllWards {
  
  final String wards;
  final String success;
  final String message;

  GetAllWards({
    required this.wards,
    required this.success,
    required this.message,
  });

  factory GetAllWards.fromJson(Map<String, dynamic> json) {
    return GetAllWards(
      wards: json['wards'],
      success: json['success'],
      message: json['message']
    );
  }
}