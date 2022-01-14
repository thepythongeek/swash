import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/components.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/get_profile.dart';
import 'package:swash/object/update_profile.dart';
import 'package:swash/object/upload_dp.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  late final TextEditingController location = TextEditingController(
      text: notFreshProfile != null ? notFreshProfile!.location : null);
  late final TextEditingController dob = TextEditingController(
      text: notFreshProfile != null ? notFreshProfile!.dob : null);
  late final TextEditingController profession = TextEditingController(
      text: notFreshProfile != null ? notFreshProfile!.profession : null);
  late final TextEditingController bio = TextEditingController(
      text: notFreshProfile != null ? notFreshProfile!.bio : null);
  final _formkey = GlobalKey<FormState>();
  DateTime? _dob;
  XFile? _xfile;
  ImagePicker _picker = ImagePicker();
  bool updatePic = false;
  late Profile? notFreshProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Add Profile Photo',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    !updatePic && notFreshProfile!.profilePic != null
                        ? createProfile(
                            radius: 80,
                            path: notFreshProfile!.profilePic,
                            network: true)
                        : createProfile(
                            radius: 80,
                            path: _xfile != null ? _xfile!.path : null,
                            network: false),
                    TextButton(
                        onPressed: () async {
                          await pickImage();
                          if (_xfile != null) {
                            ProfileManager profileManager =
                                Provider.of<ProfileManager>(context,
                                    listen: false);
                            createUploadDp(
                                    profileManager.user!.id,
                                    base64Encode(
                                        File(_xfile!.path).readAsBytesSync()))
                                .then((value) {
                              print(111);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value.message)));
                              getProfile(profileManager.user!.id, "null")
                                  .then((value) {
                                profileManager.updateprofile(value.profile);
                              });
                            });
                          }
                        },
                        child: Text(
                          'Select photo',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ]),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'cannot be blank';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Address',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: Consumer<AppStateManager>(
                      builder: (context, value, child) {
                        return TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: value.date != null
                                  ? '${value.date!.year}-${value.date!.month < 9 ? '0' + value.date!.month.toString() : value.date!.month}-${value.date!.day > 9 ? value.date!.day : '0' + value.date!.day.toString()}'
                                  : null),
                          onTap: () async {
                            DateTime date = DateTime(1800);
                            _dob = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: date,
                                lastDate: DateTime.now(),
                                currentDate: DateTime.now());

                            if (_dob != null) {
                              value.addDate(_dob!);
                            }
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Date of birth',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'cannot be blank';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'cannot be blank';
                        }
                        return null;
                      },
                      controller: profession,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Tell us your profession',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      controller: bio,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'cannot be blank';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Tell us about yourself',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            DateTime _pickedDate = Provider.of<AppStateManager>(
                                    context,
                                    listen: false)
                                .date!;
                            updateProfile(
                                    location: location.text,
                                    profession: profession.text,
                                    bio: bio.text,
                                    userId: Provider.of<ProfileManager>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    dob:
                                        '${_pickedDate.year}-${_pickedDate.month < 9 ? '0' + _pickedDate.month.toString() : _pickedDate.month}-${_pickedDate.day > 9 ? _pickedDate.day : '0' + _pickedDate.day.toString()}')
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            });
                          }
                        },
                        child: Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ))),
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    location.dispose();
    bio.dispose();
    profession.dispose();
    dob.dispose();
    super.dispose();
  }

  @override
  void initState() {
    notFreshProfile =
        Provider.of<ProfileManager>(context, listen: false).user!.profile;
    super.initState();
  }

  Future<void> pickImage() async {
    // this function/method enables a user to pick image
    // from camera or gallery
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      XFile? file =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        _xfile = file;
                        updatePic = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('gallery'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        XFile? file = await _picker.pickImage(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.front);
                        setState(() {
                          _xfile = file;
                          updatePic = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('camera'))
                ],
              ),
            ),
          );
        });
  }
}
