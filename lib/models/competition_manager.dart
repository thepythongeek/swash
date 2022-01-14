import 'package:flutter/material.dart';
import 'package:swash/Screens/School/main.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/get_top_voters.dart';

class CompetitionManager extends ChangeNotifier {
  String? _id;
  List? _schools;
  List<Voter>? _ambassadors;
  DataProvider? _provider;
  bool _loading = true;

  List? get school => _schools;
  List<Voter>? get ambassadors => _ambassadors;
  bool get loading => _loading;
  String get id => _id!;
  DataProvider? get dataProvider => _provider;

  void addId(String id) {
    _loading = true;
    _id = id;
    getSchools(id.toString());
  }

  void addVotingId(String id) {
    // _loading = true;
    _id = id;
    getAmbassador(id.toString());
  }

  Future getSchools(String id) async {
    GetLeagueTable league = await getLeaguetable(id);
    _schools = league.schools;
    _loading = false;
    notifyListeners();
  }

  void reset() {
    _id = null;
    _schools = null;
    _ambassadors = null;
  }

  Future getAmbassador(String id) async {
    TopVoters voters = await getTopVoters(id);
    _ambassadors = voters.voters;
    getDataProvider(_ambassadors!);
    _loading = false;
    notifyListeners();
  }

  void getDataProvider(List<Voter> voters) {
    _provider = DataProvider(voters: voters);
  }
}
