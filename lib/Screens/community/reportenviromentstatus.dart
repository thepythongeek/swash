import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/loading_button.dart';
import 'package:swash/components/media.dart';
import 'package:swash/object/new_env_status.dart';
import '../../models/models.dart';

class ReportEnvironmentStatus extends StatefulWidget {
  const ReportEnvironmentStatus({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportEnvironmentStatusState();
}

class _ReportEnvironmentStatusState extends State<ReportEnvironmentStatus> {
  String? _value = 'Average';
  TextEditingController location = TextEditingController();
  TextEditingController descr = TextEditingController();

  @override
  void dispose() {
    location.dispose();
    descr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EnvironmentManager env =
        Provider.of<EnvironmentManager>(context, listen: false);
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: const Text('Report Environment Status')),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Form(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      controller: location,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Location name',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      controller: descr,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Description',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    child: DropdownButton<String>(
                      hint: const Text('Select status of area'),
                      value: _value,
                      isExpanded: true,
                      items: <String>['Average', 'Bad', 'Good']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _value = newValue;
                        });
                      },
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: const BoxDecoration(),
                  ),
                  Media(),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: LoadingButton(
                      function: () async {
                        // send data
                        await createNewEnvStatus(
                            image: env.image,
                            status: _value!,
                            userId: profileManager.user!.id,
                            description: descr.text,
                            locationName: location.text);
                      },
                      child: const Text(
                        'Report',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  )
                ],
              ),
            )));
  }
}
