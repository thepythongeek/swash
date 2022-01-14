import 'package:flutter/material.dart';
import 'package:swash/Screens/community/environmentdetails.dart';
import 'package:swash/Screens/community/reportenviromentstatus.dart';
import 'package:swash/components/environment_card.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/enviromental_status.dart';

class EnvironmentalStatus extends StatefulWidget {
  const EnvironmentalStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnvironmentalStatusState();
}

class _EnvironmentalStatusState extends State<EnvironmentalStatus> {
  List<Environment> details = [];
  bool _loading = true;

  @override
  void initState() {
    fetchEnviromentalStatus().then((value) {
      setState(() {
        details = value.details;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportEnvironmentStatus()));
          },
        ),
        body: _loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  Environment environment = details[index];
                  return EnvironmentCard(environment: environment);
                }));
  }
}
