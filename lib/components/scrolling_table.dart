import 'package:flutter/material.dart';
import 'package:swash/components/rate.dart';
import 'package:swash/utility/rating.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';

class ScrollingTable extends StatefulWidget {
  final bool school;
  const ScrollingTable({Key? key, this.school = true}) : super(key: key);

  @override
  _ScrollingTableState createState() => _ScrollingTableState();
}

class _ScrollingTableState extends State<ScrollingTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompetitionManager>(
      builder: (context, competitionManager, child) {
        print(competitionManager.school);
        return ListView(primary: true, children: [
          InteractiveViewer(
            child: FittedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: widget.school
                        ? const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('School Name')),
                            DataColumn(label: Text('Built')),
                            DataColumn(label: Text('Score/100')),
                            DataColumn(label: Text('Status'))
                          ]
                        : const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Points')),
                          ],
                    rows: competitionManager.loading
                        ? []
                        : buildRows(widget.school
                            ? competitionManager.school
                            : competitionManager.ambassadors)),
              ),
            ),
          ),
        ]);
      },
    );
  }

  List<DataRow> buildRows(List? schools) {
    if (schools == null) {
      return [];
    }
    int count = 1;
    List<DataRow> rows = [];
    for (var school in schools) {
      if (widget.school) {
        rows.add(DataRow(cells: [
          DataCell(Text('${count++}')),
          DataCell(Text(school['school_name'])),
          DataCell(Text(school['built'] ?? '-')),
          DataCell(Text(double.parse(school['score']).round().toString())),
          DataCell(
            Rating(rating: findRating(school['score'])),
          ),
        ]));
      } else {
        Voter voter = school as Voter;
        rows.add(DataRow(cells: [
          DataCell(Text('${count++}')),
          DataCell(Text(voter.name)),
          DataCell(Text(double.parse(voter.votes).round().toString())),
        ]));
      }
    }
    return rows;
  }
}
