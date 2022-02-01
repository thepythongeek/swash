import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swash/components/loading_button.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/object/add_prize.dart';
import 'dart:io';

class PrizeForm extends StatefulWidget {
  const PrizeForm({Key? key}) : super(key: key);

  @override
  _PrizeFormState createState() => _PrizeFormState();
}

class _PrizeFormState extends State<PrizeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController points = TextEditingController();
  final TextEditingController body = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _xFile;
  bool _upload = false;

  @override
  void dispose() {
    points.dispose();
    body.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Weka Zawadi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: points,
                      decoration:
                          InputDecoration(label: Text('Weka idadi ya kura')),
                    ),
                  ),
                  Flexible(fit: FlexFit.loose, child: Row()),
                  Container(
                    // decoration:
                    ///   BoxDecoration(color: Colors.black54.withOpacity(.45)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: body,
                      maxLines: 10,
                      maxLength: 100,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      decoration: InputDecoration(
                          labelText: 'Elezea zawadi yako',
                          hintText: 'Elezea zawadi yako',
                          filled: true,
                          fillColor: Colors.white38.withOpacity(1),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                _xFile = await _imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  _upload = true;
                                });
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      CircleBorder())),
                              child: Icon(Icons.add),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Text('Unaweza kuweka picha'),
                        if (_upload)
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.file(File(_xFile!.path)),
                          )
                      ],
                    ),
                  ),
                  Flexible(fit: FlexFit.loose, child: Row()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: LoadingButton(
                        function: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              String value = await addPrize(
                                  content: body.text,
                                  points: points.text,
                                  image: _xFile);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            } on NetworkError catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                            }
                            /* addPrize(
                                    content: body.text,
                                    points: points.text,
                                    image: _xFile)
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            }).catchError(
                              (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                              },
                              test: (error) => error is NetworkError,
                            );*/
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('SUBMIT'),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
