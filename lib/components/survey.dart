import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/components.dart';
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
                    createUploadPhoto(File(widget.xfile.path), widget.schoolId,
                            qnsOne.text, qnsTwo.text, widget.competitionId)
                        .then((value) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text('FINISH UPLOAD'))
          ],
        ),
      ),
    );
  }
}
