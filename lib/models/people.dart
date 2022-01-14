class People {
  final bool success;
  final List profiles;

  People({required this.success, required this.profiles});

  factory People.fromJson(Map<String, dynamic> json) {
    return People(success: json['success'], profiles: json['profiles']);
  }
}
