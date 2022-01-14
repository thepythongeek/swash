class ChangePassword {
  final bool success;
  final String message;
  ChangePassword({required this.success, required this.message});

  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(
      success: json['success'],
      message: json['message']
    );
  }
}