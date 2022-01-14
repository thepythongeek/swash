import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:swash/utility/rating.dart';

final pdf = pw.Document();

void createPDF(List<dynamic> data, BuildContext buildcontext) {
  List<List> _rows = [];
  int index = 1;
  List _row = [];
  for (Map i in data) {
    i.remove('school_id');
    i.remove('competition_id');
    i.remove('competition_name');
    _row = i.values.toList();
    _row.add(findRating(i['score']));
    _row.insert(0, index++);
    _rows.add(_row);
  }
  print(_rows);
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return /* pw.FittedBox(
            child: pw.Table(
                children: List.generate(data.length, (index) {
          return pw.TableRow(children: [
            pw.Text(data[index]['school_name']),
            pw.Text(data[index]['address']),
            pw.Text(data[index]['theme']),
            pw.Text(data[index]['built'] ?? ''),
            pw.Text(data[index]['score']),
          ]);
        })));*/
            pw.Table.fromTextArray(
                context: context,
                data: _rows,
                headerCount: 5,
                headers: ['No', 'Name', 'Score', 'Theme', 'Built', 'Address']);
      }));
  savePDF().then((value) {
    ScaffoldMessenger.of(buildcontext)
        .showSnackBar(const SnackBar(content: Text('table downloaded')));
  }).catchError((error) {
    ScaffoldMessenger.of(buildcontext)
        .showSnackBar(SnackBar(content: Text('$error')));
  });
}

Future<String> savePDF() async {
  final tempDir = await getExternalStorageDirectory();
  print(tempDir!.path);
  String path = tempDir.path.split('Android')[0] + 'Download';
  final file = File('$path/swash.pdf');
  await file.writeAsBytes(await pdf.save());
  String s = 'Android';
  return tempDir.path + '/swash.pdf';
}
