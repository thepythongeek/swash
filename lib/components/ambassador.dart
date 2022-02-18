import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/School/main.dart';
import 'package:swash/models/models.dart';
import '../components/components.dart' as components;

class Ambassador extends StatefulWidget {
  const Ambassador({Key? key}) : super(key: key);

  @override
  State<Ambassador> createState() => _AmbassadorState();
}

class _AmbassadorState extends State<Ambassador> {
  @override
  Widget build(BuildContext context) {
    CompetitionManager competitionManager = context.watch<CompetitionManager>();
    competitionManager.ambassadors;
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: const Text(
            'Recognition: Best WASH Ambassadors',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const components.ButtonWidget(
          school: false,
        ),
        if (competitionManager.loading)
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (!competitionManager.loading)
          Flexible(
              child: components.ScrollingTable(
            school: false,
          ))
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
