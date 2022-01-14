class Views {
  final int likes;
  final int views;
  final int comments;

  Views({required this.comments, required this.likes, required this.views});

  factory Views.fromJson(Map json) {
    return Views(
        comments: int.parse(json['comments'] ?? '0'),
        likes: int.parse(json['likes'] ?? '0'),
        views: int.parse(json['views'] ?? '0'));
  }
}
