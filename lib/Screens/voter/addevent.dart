import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http_parser/http_parser.dart';
import '../../path.dart';
import 'package:path/path.dart';
import '../../models/models.dart';
import "package:async/async.dart";
import 'package:swash/toasty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import '../../components/mediaplayer.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future postEvent(
    {required String title,
    required String descriptions,
    required var multipartFile,
    required String mediaType,
    String duration = '',
    required String userID}) async {
  var request = http.MultipartRequest(
      "POST", Uri.parse('${AppPath.domain}/post_event.php'));

  request.files.add(multipartFile);
  request.fields['user_id'] = userID;
  request.fields['duration'] = duration;
  request.fields['title'] = title;
  request.fields['descriptions'] = descriptions;
  request.fields['media_type'] = mediaType;

  var response = await request.send();
  if (response.statusCode == 200) {
    var resp = await response.stream.bytesToString();
    print(resp);
    var data = jsonDecode(resp);

    if (data['status'] == true) {
      Toasty().show(data['message'], Toast.LENGTH_SHORT, ToastGravity.TOP);
    } else {
      Toasty().show(data['message'], Toast.LENGTH_SHORT, ToastGravity.TOP);
    }
  } else {
    Toasty().show("Failed to ", Toast.LENGTH_SHORT, ToastGravity.TOP);
  }
}

class EventForm extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.eventform,
        key: ValueKey(MyPages.eventform),
        child: EventForm());
  }

  const EventForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final FileManager fileManager =
        Provider.of<FileManager>(context, listen: false);
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionsController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('Add Event')),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              fileManager.reset();
                              XFile? file = await chooseImage(
                                  source: ImageSource.gallery);
                              fileManager.addFile(file!);
                              Navigator.pop(context);
                            },
                            child: Text('Gallery'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              fileManager.reset();
                              XFile? file =
                                  await chooseImage(source: ImageSource.camera);
                              fileManager.addFile(file!);
                              Navigator.pop(context);
                            },
                            child: Text('camera'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              fileManager.reset();
                              XFile? file = await _imagePicker.pickVideo(
                                  source: ImageSource.camera,
                                  maxDuration: const Duration(seconds: 30));
                              fileManager.addFile(file!);
                              fileManager.showVideo();
                              Navigator.pop(context);
                            },
                            child: Text('video'),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Icon(Icons.camera),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Form(
              child: ListView(
                children: [
                  Container(
                    child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Title ',
                          border: InputBorder.none,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: TextFormField(
                        controller: descriptionsController,
                        decoration: const InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          labelText: 'Description ',
                        )),
                  ),
                  Consumer<FileManager>(builder: (context, manager, child) {
                    return MediaPlayer(
                      file: manager.file,
                      isVideo: manager.video,
                    );
                  }),
                  if (profileManager.user!.role == 'admin') SetDuration(),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        http.MultipartFile multipartFile;
                        if (fileManager.video == 'video') {
                          multipartFile = await http.MultipartFile.fromPath(
                              'image', fileManager.file!.path,
                              contentType: MediaType('video', 'mp4'));
                        } else {
                          multipartFile = await http.MultipartFile.fromPath(
                              'image', fileManager.file!.path);
                        }

                        final title = titleController.text;
                        final descriptions = descriptionsController.text;

                        if (title != "" || descriptions != "") {
                          postEvent(
                                  title: title,
                                  mediaType:
                                      fileManager.video ? 'video' : 'image',
                                  multipartFile: multipartFile,
                                  userID: profileManager.user!.id,
                                  duration: appStateManager.duration != null
                                      ? appStateManager.duration.toString()
                                      : '',
                                  descriptions: descriptions)
                              .then((value) {
                            fileManager.reset();
                          });
                        } else {
                          Toasty().show("At least one field must be filled.",
                              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<XFile?> chooseImage({required ImageSource source}) async {
    XFile? choosedimage = await _imagePicker.pickImage(source: source);
    return choosedimage;
  }
}

class SetDuration extends StatefulWidget {
  const SetDuration({Key? key}) : super(key: key);

  @override
  _SetDurationState createState() => _SetDurationState();
}

class _SetDurationState extends State<SetDuration> {
  double _value = 0.0;
  double _max = 1.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
          divisions: 10,
          max: _max,
          label: process(_value),
          value: _value,
          onChanged: (newvalue) {
            setState(() {
              _value = newvalue;
            });
            Provider.of<AppStateManager>(context, listen: false)
                .addDuration(newvalue.round());
          }),
    );
  }

  String process(double value) {
    // convert to days if necessary
    if (value / 60 < 1) {
      return '${value}mins';
    } else if (value / 60 >= 1 && value / (60 * 24) < 1) {
      return '${value ~/ 60}hrs';
    } else if (value / (60 * 24) >= 1) {
      return '${value ~/ (60 * 24)}days';
    }
    return value.round().toString();
  }
}
