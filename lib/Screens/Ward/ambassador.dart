import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ambassador extends StatelessWidget {
  const Ambassador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: ButtonWidget()
          );

  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({Key? key}): super(key: key);
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();

}

class _ButtonWidgetState extends State<ButtonWidget>{
  String? _value = 'Current Challenge Results(Press to Change)';
  @override
  Widget build(BuildContext context){
    return Column(
    children: [
      Container(
        child: DropdownButton<String>(
          value: _value,
        style: const TextStyle(
          color: Colors.deepOrange
        ),
        icon: const Icon(Icons.arrow_downward),
    //  menuMaxHeight: 300.0,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
        items: <String>['Current Challenge Results(Press to Change)', 'Active Competition', 'General Ambassadors'].map<DropdownMenuItem<String>>(
            (String value){
              return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value));
            }
        ).toList(),
      onChanged: (String? newValue){
          setState(() {
            _value = newValue;
          });
      },
    ),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: const BoxDecoration(
      ),
    ),

      FittedBox(

      child:
      DataTable(
        columns: const <DataColumn>[
          DataColumn(
              label: Text('No')),
          DataColumn(
              label: Text('Ambassador Name')),
          DataColumn(
              label: Text('Point')),
          DataColumn(
              label: Text('Level')),

        ],
        rows: const [
          DataRow(
              cells: [
                DataCell(Text('1')),
                DataCell(Text('Ally Shengena')),
                DataCell(Text('191')),
                DataCell(Text('2')),
              ]),
          DataRow(
              cells: [
                DataCell(Text('2')),
                DataCell(Text('Bakorani Primary School')),
                DataCell(Text('192')),
                DataCell(Text('2')),

              ])
        ],

      ))
    ]
    );
}
}