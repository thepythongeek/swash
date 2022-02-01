import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/School/main.dart';
import 'package:swash/models/models.dart';

class Ambassador extends StatefulWidget {
  const Ambassador({Key? key}) : super(key: key);

  @override
  State<Ambassador> createState() => _AmbassadorState();
}

class _AmbassadorState extends State<Ambassador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      primary: true,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: const Text(
            'Recognition: Best WASH Ambassadors',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const ButtonWidget(),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: const [
                Text('No'),
                Spacer(),
                Text('Name'),
                Spacer(),
                Text('Points'),
                Spacer(),
                Text('level'),
              ],
            ),
          ),
        ),
        Consumer<CompetitionManager>(
            builder: (context, competitionManager, child) {
          print(competitionManager.loading);
          if (competitionManager.loading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return scrollingTable(competitionManager.ambassadors!);
            // return table(Provider.of<CompetitionManager>(context, listen: false)
            //  .dataProvider!);
          }

          /*FittedBox(
              child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Ambassador Name')),
              DataColumn(label: Text('Point')),
              DataColumn(label: Text('Level')),
            ],
            rows: competitionManager.loading
                ? []
                : buildRows(competitionManager.ambassadors),
          ));*/
        })
      ],
    ));
  }

  List<DataRow> buildRows(List<Voter> voters) {
    int count = 1;
    List<DataRow> rows = [];
    for (var ambassador in voters) {
      rows.add(DataRow(cells: [
        DataCell(Text('${count++}')),
        DataCell(Text(ambassador.name)),
        DataCell(Text(ambassador.votes)),
        const DataCell(Text('1')),
      ]));
    }
    return rows;
  }

  Widget table(DataProvider provider) {
    TextStyle font = const TextStyle(fontSize: 11);
    return PaginatedDataTable(
      showCheckboxColumn: false,
      columns: <DataColumn>[
        DataColumn(
            label: Text(
          'No',
          style: font,
        )),
        DataColumn(
            label: Text(
          'Ambassador Name',
          style: font,
        )),
        DataColumn(
            label: Text(
          'Point',
          style: font,
        )),
        DataColumn(
            label: Text(
          'Level',
          style: font,
        )),
      ],
      source: provider,
      rowsPerPage: 20,
    );
  }

  Widget scrollingTable(List<Voter> voters) {
    TextStyle fontsize = const TextStyle(fontSize: 12);
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: voters.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: fontsize,
                  ),
                  const Spacer(),
                  Text(
                    voters[index].name,
                    textAlign: TextAlign.center,
                    style: fontsize,
                  ),
                  const Spacer(),
                  Text(
                    voters[index].votes,
                    textAlign: TextAlign.center,
                    style: fontsize,
                  ),
                  const Spacer(),
                  Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: fontsize,
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({Key? key}) : super(key: key);
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  List _details = [];
  bool _loading = true;
  String? _selectedMenuItem;
  Map<String, String> activeCompetition = {
    'id': 'active',
    'name': 'Active Competition'
  };
  Map<String, String> general = {
    'id': 'general',
    'name': 'General ambassadors'
  };

  @override
  void initState() {
    getCompetitions().then((value) {
      _details = value.competitions + [activeCompetition, general];
      Provider.of<CompetitionManager>(context, listen: false)
          .addVotingId(_details[0]['id']);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.all(1),
          child: Text(_loading
              ? "Current Challenge Results(Press to Change)"
              : "${_details[0]['name']}"),
        ),
        value: _selectedMenuItem,
        items: _loading
            ? []
            : _details.map((value) {
                return DropdownMenuItem<String>(
                    value: value['id'], child: Text(value['name']));
              }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedMenuItem = newValue;
            Provider.of<CompetitionManager>(context, listen: false)
                .addVotingId(newValue!);
          });
        },
      ),
      margin: const EdgeInsets.all(10),
    );
  }
}
