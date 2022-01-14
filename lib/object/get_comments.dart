class GetComments {
  final String success;
  final String comments; // array

  GetComments({required this.success, required this.comments});

  factory GetComments.fromJson(Map<String, dynamic> json) {
    return GetComments(success: json['success'], comments: json['comments']);
  }
}
