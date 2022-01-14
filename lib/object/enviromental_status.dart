import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../path.dart';

Future<EnviromentalDetails> fetchEnviromentalStatus() async {
  final response =
      await http.post(Uri.parse('${AppPath.domain}/enviromental_status.php'));
  if (response.statusCode == 200) {
    return EnviromentalDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load enviromental status');
  }
}
