class GetLeagueTable {

  var schools = [];
  final bool success;
  final String message;

  GetLeagueTable({ 
    required this.success, 
    required this.message, required this.schools });

  factory GetLeagueTable.fromJson(Map<String, dynamic> json) {
    return GetLeagueTable(
      success: json['success'],
      message: json['message'],
      schools: json['schools'],
    );
  }
}