class Prize {
  String id;
  String status;
  String content;
  String? userId;
  String? image;

  Prize(
      {required this.id,
      required this.status,
      required this.content,
      this.image,
      this.userId});

  factory Prize.fromjson(Map<String, dynamic> json) {
    return Prize(
        id: json['id'],
        status: json['status'],
        content: json['content'],
        userId: json['user_id'],
        image: json['image']);
  }
}
