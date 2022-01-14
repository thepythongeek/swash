import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swash/components/components.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/models.dart';
import 'package:swash/models/pages.dart';
import 'package:swash/models/themes.dart';
import 'package:swash/object/get_competition_details.dart';
import 'package:swash/object/upload_photo.dart';
import '../path.dart';

class ChallengeDetail extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.challenge,
        key: ValueKey(MyPages.challenge),
        child: ChallengeDetail());
  }

  const ChallengeDetail({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChallengeDetailState();
}

class _ChallengeDetailState extends State<ChallengeDetail> {
  List<Map<String, dynamic>> _images = [];
  GetCompetitionDetails? _details;
  ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  static List roles = ['admin', 'voter'];

  @override
  void initState() {
    print(111);
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);
    if (!roles.contains(profileManager.user!.role)) {
      print(profileManager.user!.role);
      getCompetitionDetails(
              themeManager.getTheme.id,
              profileManager.user!.role == 'teacher'
                  ? profileManager.user!.profile!.school!['id']
                  : profileManager.user!.profile!.ward!['id'])
          .then((value) {
        setState(() {
          _details = value;
          _images = value.images;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);
    print(themeManager.getTheme.status);
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              appStateManager.goto(MyPages.challenge, false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('THEME:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(themeManager.getTheme.theme),
        ),
        Container(
          padding: EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('CHALLENGE NAME:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(15),
          child: Text(themeManager.getTheme.title),
        ),
        Container(
          padding: EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('CRITERIA REWARD:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Criteria: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                themeManager.getTheme.criteria,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Reward:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                themeManager.getTheme.reward,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        if (profileManager.user!.role == 'teacher' ||
            profileManager.user!.role == 'ward')
          _details != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: const Color.fromRGBO(232, 232, 232, 10),
                      child: const Text('SUBSCRIPTION:',
                          style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Shools Subscribed: ${_details!.noSubscribed}',
                          ),
                          Text('Image Shared: ${_details!.totalImages}'),
                          Container(
                              alignment: AlignmentDirectional.center,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80.0)),
                                  onPressed: () {},
                                  child: Text(_details!.isSubscribed
                                      ? 'Subscribed'
                                      : 'Unsubscribed')))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: const Color.fromRGBO(232, 232, 232, 10),
                      child: const Text('IMAGE SHARED:',
                          style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: ListView.builder(
                            itemCount: _images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.black.withOpacity(.65),
                                elevation: 12,
                                child: Image.network(
                                  '${AppPath.server}/${_images[index]['url']}',
                                  fit: BoxFit.contain,
                                ),
                              );
                            })),
                    if (_imageFile != null)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.black.withOpacity(.78),
                            elevation: 45,
                            child: Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    if (themeManager.getTheme.status != 'ended')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: onPickImage,
                            child: Text('Take photo '),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        content: SurveyForm(
                                      xfile: _imageFile!,
                                      schoolId: profileManager
                                          .user!.profile!.school!['id'],
                                      competitionId: themeManager.getTheme.id,
                                    ));
                                  });
                            },
                            child: Text('Upload'),
                          )
                        ],
                      )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
      ]),
    );
  }

  Future<void> onPickImage({
    ImageSource source = ImageSource.camera,
    int? quality = 90,
  }) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: quality);
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
