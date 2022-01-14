class GetImagesToVote {

  var  images = [];
  late int success;
  late String message;
  late int competitionName;
  late String competitionId;
  late int competitionTheme;
  late String competitionStatus;
  late String competitionCaption;

  GetImagesToVote(
    this.images, this.success,
    this.message, this.competitionCaption, this.competitionName,
    this.competitionId, this.competitionTheme, this.competitionStatus);

  GetImagesToVote.fromJson(Map<String, dynamic> json) {
      images = json['images'];
      message = json['message'];
      success = json['success'];
      competitionId = json['competition_id'];
      competitionName = json['competition_name'];
      competitionTheme = json['competition_theme'];
      competitionStatus = json['competition_status'];
      competitionCaption = json['competition_caption'];
  }
}