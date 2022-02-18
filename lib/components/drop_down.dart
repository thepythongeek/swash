import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../components/components.dart';

class ButtonWidget extends StatefulWidget {
  final bool school;
  const ButtonWidget({Key? key, this.school = true}) : super(key: key);
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  late Future<GetCompetition> profile;
  bool initialise = false;
  late String initialValue;
  String? _selectedMenuItem;
  Map<String, String> activeCompetition = {
    'id': 'active',
    'theme': 'Active Competition'
  };
  Map<String, String> general = {
    'id': 'general',
    'theme': 'General ambassadors'
  };

  @override
  void initState() {
    profile = getCompetitions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetCompetition>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GetCompetition getCompetition = snapshot.data!;
            var _details = getCompetition.competitions;
            if (!initialise) {
              if (!widget.school) {
                _details.add(activeCompetition);
                _details.add(general);
              }

              !widget.school
                  ? Provider.of<CompetitionManager>(context, listen: false)
                      .addVotingId(_details[0]['id'])
                  : Provider.of<CompetitionManager>(context, listen: false)
                      .addId(_details[0]['id']);
              initialise = true;
            }
            print(_details);

            initialValue = _details[0]['id'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Text("${_details[0]['theme']}"),
                ),
                value: _selectedMenuItem == null
                    ? initialValue
                    : _selectedMenuItem,
                items: _details.map((value) {
                  return DropdownMenuItem<String>(
                      value: value['id'], child: Text(value['theme']));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMenuItem = newValue;
                    !widget.school
                        ? Provider.of<CompetitionManager>(context,
                                listen: false)
                            .addVotingId(_details[0]['id'])
                        : Provider.of<CompetitionManager>(context,
                                listen: false)
                            .addId(_details[0]['id']);
                  });
                },
              ),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Hitilafu imetokea'),
            );
          }
          return Container(
            color: Colors.grey,
          );
        });
  }
}
