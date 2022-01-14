import 'package:flutter/cupertino.dart';
import 'dart:io';

class EnviromentalDetails {
  List<Environment> details;

  EnviromentalDetails({
    required this.details,
  });

  factory EnviromentalDetails.fromJson(Map<String, dynamic> json) {
    List<Environment> details = [];
    for (Map<String, dynamic> data in json['eas']) {
      details.add(Environment.fromJson(data));
    }
    return EnviromentalDetails(details: details);
  }
}

class Environment {
  final String id;
  final String userId;
  final String locationName;
  final String longitude;
  final String lattitude;
  final String description;
  final String imageUrl;
  final String timesReported;
  final String status;
  final String updatedAt;

  Environment(
      {required this.id,
      required this.description,
      required this.imageUrl,
      required this.lattitude,
      required this.locationName,
      required this.longitude,
      required this.status,
      required this.timesReported,
      required this.updatedAt,
      required this.userId});

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
        id: json['id'],
        description: json['description'],
        imageUrl: json['image_url'],
        lattitude: json['latitude'],
        locationName: json['location_name'],
        longitude: json['longitude'],
        status: json['status'],
        timesReported: json['times_reported'],
        updatedAt: json['updated_at'],
        userId: json['user_id']);
  }
}

class EnvironmentManager extends ChangeNotifier {
  Environment? _environment;
  Map? _image;

  Environment? get environment => _environment;
  Map get image => _image!;

  void add(Environment environment) {
    _environment = environment;
    notifyListeners();
  }

  void clear() {
    _environment = null;
    notifyListeners();
  }

  void getImage(Map file) {
    _image = file;
  }
}
