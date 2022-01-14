class GetCompetition {
  final bool success;
  final String message;
  var competitions = [];

  GetCompetition(
      {required this.success,
      required this.message,
      required this.competitions});

  factory GetCompetition.fromJson(Map<String, dynamic> json) {
    return GetCompetition(
        success: json['success'],
        message: json['message'],
        competitions: json['competitions']);
  }
}

class GetCompetitionDetails {
  List<Map<String, dynamic>> images;
  final bool isSubscribed;
  final String noSubscribed;
  final String totalImages;

  GetCompetitionDetails(
      {required this.images,
      required this.isSubscribed,
      required this.noSubscribed,
      required this.totalImages});

  factory GetCompetitionDetails.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> images = [];
    for (Map<String, dynamic> image in json['images']) {
      images.add(image);
    }

    return GetCompetitionDetails(
        images: images,
        totalImages: json['total_images'],
        isSubscribed: json['is_subscribed'],
        noSubscribed: json['no_subscribed']);
  }
}
