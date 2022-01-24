import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/components.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/themes.dart';
import 'package:swash/object/get_themes.dart';
import 'package:swash/object/upload_photo.dart';

class SurveyForm extends StatefulWidget {
  final XFile xfile;
  final String schoolId;
  final String competitionId;
  SurveyForm(
      {Key? key,
      required this.xfile,
      required this.competitionId,
      required this.schoolId})
      : super(key: key) {
    print(schoolId);
    print(competitionId);
  }

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController qnsOne = TextEditingController();
  TextEditingController qnsTwo = TextEditingController();

  @override
  void dispose() {
    qnsOne.dispose();
    qnsTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<ThemeManager>(context, listen: false).getTheme;
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Image.file(File(widget.xfile.path)),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: TextFormField(
                controller: qnsOne,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(theme.qnsOne),
                    hintText: theme.qnsOneField),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: TextFormField(
                controller: qnsTwo,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(theme.qnsTwo),
                    hintText: theme.qnsTwoField),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('999');
                    if (calculateDistance(profileManager.user!.profile!.school!,
                        appStateManager.position!)) {
                      createUploadPhoto(
                              File(widget.xfile.path),
                              widget.schoolId,
                              qnsOne.text,
                              qnsTwo.text,
                              widget.competitionId)
                          .then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(value)));
                        Navigator.pop(context);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'It seems you are no where near the school, you need to be around the school to take this photo')));
                    }
                  }
                },
                child: const Text('FINISH UPLOAD'))
          ],
        ),
      ),
    );
  }
}

bool calculateDistance(Map school, Position location) {
  // get distance between school location and where the image was taken
  double sLongitude = (double.parse(school['longitude']) / 360) * 2 * pi;
  double sLatitude = (double.parse(school['latitude']) / 360) * 2 * pi;

  double longitude = (location.longitude.toDouble() / 360) * 2 * pi;
  double latitude = (location.latitude.toDouble() / 360) * 2 * pi;

  double distance =
      sqrt(pow((latitude - sLatitude), 2) + pow(longitude - sLongitude, 2));
  distance = 111 * distance;

  print(distance);
  if (distance > double.parse(school['radius'])) {
    return false;
  }
  return true;
}
