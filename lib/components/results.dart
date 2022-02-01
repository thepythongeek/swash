import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swash/components/components.dart';
import 'package:swash/models/competition.dart';
import 'package:swash/models/competition_manager.dart';
import 'package:swash/models/league_table.dart';
import 'package:provider/provider.dart';
import 'package:swash/utility/create_pdf.dart';
import 'package:swash/utility/rating.dart';
import '../path.dart';

Future<GetCompetition> getCompetitions() async {
  final response =
      await http.get(Uri.parse('${AppPath.domain}/get_competition.php'));
  if (response.statusCode == 200) {
    return GetCompetition.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load competition.');
  }
}

Future<GetLeagueTable> getLeaguetable(String competitionId) async {
  final response = await http.post(
      Uri.parse('${AppPath.api}/get_league_table.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName('utf-8'),
      body: {"competition_id": competitionId});
  if (response.statusCode == 200) {
    return GetLeagueTable.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load league table.');
  }
}

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List _listCompetition = [];
  late Future<GetCompetition> _getCompetitions;
  String? _selectedMenuItem;

  @override
  void initState() {
    super.initState();
    _getCompetitions = getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetCompetition>(
        future: _getCompetitions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _listCompetition = snapshot.data!.competitions;
            Provider.of<CompetitionManager>(context, listen: false)
                .addId(_listCompetition[0]['id']);
            return displayDropDownButton(
                _listCompetition, _listCompetition[0]['theme']);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('something is wrong please try again'),
            );
          } else {
            return displayDropDownButton(null, 'Current Challenge Results');
          }
        });
  }

  DropdownButton<String> displayDropDownButton(List? items, String hint) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Padding(
        padding: const EdgeInsets.all(1),
        child: Text(hint),
      ),
      items: items?.map((item) => buildDropdownMenuItem(item)).toList(),
      value: _selectedMenuItem, // values should match
      onChanged: (String? value) {
        setState(() {
          _selectedMenuItem = value;
        });
        Provider.of<CompetitionManager>(context, listen: false)
            .addId(value.toString());
      },
    );
  }

  DropdownMenuItem<String> buildDropdownMenuItem(data) {
    return DropdownMenuItem(value: data['id'], child: Text(data['theme']));
  }
}

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () {
          if (Provider.of<CompetitionManager>(context, listen: false).school !=
              null) {
            createPDF(
                Provider.of<CompetitionManager>(context, listen: false).school!,
                context);
          }
        },
      ),*/
      body: Column(children: <Widget>[
        const ListTile(title: Text('Challenge Results')),
        const DropDown(),
        Consumer<CompetitionManager>(
          builder: (context, competitionManager, child) {
            //print(competitionManager.school!);
            return FittedBox(
                child: DataTable(
                    columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('School Name')),
                  DataColumn(label: Text('Built')),
                  DataColumn(label: Text('Score/100')),
                  DataColumn(label: Text('Status'))
                ],
                    rows: competitionManager.loading
                        ? []
                        : buildRows(competitionManager.school!)));
          },
        )
      ]),
    );
  }

  List<DataRow> buildRows(List schools) {
    int count = 1;
    List<DataRow> rows = [];
    for (var school in schools) {
      print(school);
      rows.add(DataRow(cells: [
        DataCell(Text('${count++}')),
        DataCell(Text(school['school_name'])),
        DataCell(Text(school['built'] ?? '-')),
        DataCell(Text(double.parse(school['score']).round().toString())),
        DataCell(
          Rating(rating: findRating(school['score'])),
        ),
      ]));
    }
    return rows;
  }
}
