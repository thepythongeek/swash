import 'package:flutter/material.dart';
import 'models.dart';

class DataProvider extends DataTableSource {
  int count;
  final List<Voter> voters;

  DataProvider({required this.voters, this.count = 1});

  @override
  int get rowCount => voters.length;

  @override
  DataRow getRow(index) {
    TextStyle fontsize = const TextStyle(fontSize: 8);
    return DataRow(cells: [
      DataCell(Text(
        '${count++}',
        style: fontsize,
      )),
      DataCell(Text(
        voters[index].name,
        style: fontsize,
      )),
      DataCell(Text(
        voters[index].votes,
        style: fontsize,
      )),
      DataCell(Text(
        '1',
        style: fontsize,
      ))
    ]);
  }

  @override
  int get selectedRowCount => count;

  @override
  bool get isRowCountApproximate => false;
}
