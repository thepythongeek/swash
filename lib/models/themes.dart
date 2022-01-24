import 'package:flutter/cupertino.dart';

class Themes {
  String id;
  String title;
  String theme;
  String criteria;
  String reward;
  String competitionType;
  String startDate;
  String endDate;
  String status;
  String qns;
  String qnsOneField;
  String qnsOne;
  String qnsTwoField;
  String qnsTwo;

  Themes(
      {required this.id,
      required this.title,
      required this.competitionType,
      required this.criteria,
      required this.endDate,
      required this.qns,
      required this.qnsOne,
      required this.qnsOneField,
      required this.qnsTwo,
      required this.qnsTwoField,
      required this.reward,
      required this.startDate,
      required this.status,
      required this.theme});

  factory Themes.fromMap(Map data) {
    return Themes(
        id: data['id'],
        title: data['title'],
        competitionType: data['competition_type'],
        criteria: data['criteria'],
        endDate: data['end_date'],
        qns: data['no_of_qns'],
        qnsOneField: data['qn_one_field'] ?? '',
        qnsOne: data['qn_one'] ?? '',
        qnsTwo: data['qn_two'] ?? '',
        qnsTwoField: data['qn_two_field'] ?? '',
        reward: data['reward'],
        startDate: data['start_date'],
        status: data['status'],
        theme: data['theme']);
  }
}

class ThemeManager extends ChangeNotifier {
  Themes? _theme;

  Themes get getTheme => _theme!;

  void addTheme(Themes theme) {
    _theme = theme;
  }
}
