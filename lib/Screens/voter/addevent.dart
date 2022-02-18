import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:swash/components/components.dart';
import 'package:http_parser/http_parser.dart';
import 'package:swash/utility/compress_video.dart';
import 'package:video_compress/video_compress.dart';
import '../../models/models.dart';
import 'package:swash/toasty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../object/post_event.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                    height: MediaQuery.of(context).size.height / 4 + 60,
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
                              fileManager.addXFile(file!);
                              Navigator.pop(context);
                            },
                            child: Text('Gallery'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              fileManager.reset();
                              XFile? file =
                                  await chooseImage(source: ImageSource.camera);
                              fileManager.addXFile(file!);
                            },
                            child: Text('camera'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              /// check if is greater than maximum upload size
                              /// if it is compress it
                              fileManager.reset();
                              XFile? file = await _imagePicker.pickVideo(
                                  source: ImageSource.camera,
                                  maxDuration: const Duration(seconds: 30));
                              await _processVideo(file, fileManager, context);
                            },
                            child: Text('video from camera'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              /// check if is greater than maximum upload size
                              /// if it is compress it
                              fileManager.reset();
                              XFile? file = await _imagePicker.pickVideo(
                                  source: ImageSource.gallery,
                                  maxDuration: const Duration(seconds: 30));
                              await _processVideo(file, fileManager, context);
                            },
                            child: Text('video from gallery'),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: const Icon(Icons.camera),
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
                      file: manager.file != null
                          ? manager.file
                          : manager.xfile != null
                              ? File(manager.xfile!.path)
                              : null,
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
                      child: LoadingButton(
                        child: Text('Submit'),
                        function: () async {
                          http.MultipartFile? multipartFile;
                          if (fileManager.video) {
                            multipartFile = await http.MultipartFile.fromPath(
                                'image',
                                fileManager.file != null
                                    ? fileManager.file!.path
                                    : fileManager.xfile!.path,
                                contentType: MediaType('video', 'mp4'));
                          } else if (fileManager.file != null ||
                              fileManager.xfile != null) {
                            multipartFile = await http.MultipartFile.fromPath(
                              'image',
                              fileManager.file != null
                                  ? fileManager.file!.path
                                  : fileManager.xfile!.path,
                            );
                          } else {
                            multipartFile = null;
                          }

                          final title = titleController.text;
                          final descriptions = descriptionsController.text;

                          if (title != "" || descriptions != "") {
                            await postEvent(
                                title: title,
                                mediaType:
                                    fileManager.video ? 'video' : 'image',
                                multipartFile: multipartFile,
                                userID: profileManager.user!.id,
                                duration: appStateManager.duration != null
                                    ? appStateManager.duration.toString()
                                    : '',
                                descriptions: descriptions);
                            fileManager.reset();
                          } else {
                            Toasty().show("At least one field must be filled.",
                                Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
                          }
                        },
                      )),
                ],
              ),
            )));
  }

  Future<void> _processVideo(
      XFile? file, FileManager fileManager, BuildContext context) async {
    try {
      File data = await uploadVideo(file!);
      fileManager.addFile(data);
      fileManager.showVideo();
    } on FileStillBig catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 6),
          content:
              Text('Imeshindwa kutuma video, pungunza muda wa video hii')));
    } on CompressionError catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 6),
          content: Text('hitilafu imetokea jaribu video nyingine')));
    }
  }

  Future<XFile?> chooseImage({required ImageSource source}) async {
    XFile? choosedimage =
        await _imagePicker.pickImage(source: source, imageQuality: 50);
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
