import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:swash/exceptions/network.dart';
import '../path.dart';

Future<Register> register(
    {required String phone,
    required String email,
    required String location,
    required String password,
    required String fullName,
    required String schoolName}) async {
  final response = await http.post(Uri.parse('${AppPath.domain}/register.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName('utf-8'),
      body: {
        "phone": phone,
        "email": email,
        "location": location,
        "password": password,
        "full_name": fullName,
        "player_id": "",
        "school_id": "",
        "user_type": "3",
        "school_name": schoolName
      });

  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['success']) {
      print(data);
      return Register.fromJson(data);
    } else {
      throw NetworkError(msg: data['message']);
    }
  } else {
    throw NetworkError(msg: 'Failed to create register.');
  }
}

class Register {
  final bool success;
  final int userId;
  final String roleId;
  final String role;
  final String message;

  Register(
      {required this.success,
      required this.role,
      required this.userId,
      required this.roleId,
      required this.message});

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
        userId: json['user_id'],
        roleId: json['role_id'],
        message: json['message'],
        role: json['role'],
        success: json['success']);
  }
}
