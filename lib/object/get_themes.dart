class GetThemes {

  var themes = [];
  final bool success;
  final String message;

  GetThemes({
    required this.themes,
    required this.success, required this.message });

  factory GetThemes.fromJson(Map<String, dynamic> json) {
    return GetThemes(
      themes: json['themes'],
      message: json['message'],
      success: json['success']
    );
  }
}