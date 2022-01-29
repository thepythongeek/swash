import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swash/components/components.dart';

import 'package:swash/models/models.dart';
import 'package:swash/models/themes.dart';
import 'package:swash/object/get_competition_details.dart';
import 'package:swash/object/subscribe_competition.dart';

import 'package:swash/utility/location.dart';
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
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  static List roles = ['admin', 'voter'];

  @override
  void initState() {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);

    if (!roles.contains(profileManager.user!.role)) {
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
          padding: const EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('THEME:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(themeManager.getTheme.theme),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('CHALLENGE NAME:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          child: Text(themeManager.getTheme.title),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromRGBO(232, 232, 232, 10),
          child: const Text('CRITERIA REWARD:', style: TextStyle(fontSize: 20)),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Criteria: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                themeManager.getTheme.criteria,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: const Text(
                  'Reward:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                themeManager.getTheme.reward,
                style: const TextStyle(
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
                      padding: const EdgeInsets.all(10),
                      color: const Color.fromRGBO(232, 232, 232, 10),
                      child: const Text('SUBSCRIPTION:',
                          style: TextStyle(fontSize: 20)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 80.0)),
                                  onPressed: _details!.isSubscribed
                                      ? null
                                      : () {
                                          subscribeCompetition(
                                                  profileManager.user!.profile!
                                                      .school!['id'],
                                                  themeManager.getTheme.id)
                                              .then((value) {
                                            String message;
                                            if (value) {
                                              message =
                                                  'you subscribed successfully';
                                            } else {
                                              message =
                                                  'subcribing to this competiton failed';
                                            }
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(message)));
                                          });
                                        },
                                  child: Text(_details!.isSubscribed
                                      ? 'Subscribed'
                                      : 'Subscribe')))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: const Color.fromRGBO(232, 232, 232, 10),
                      child: const Text('IMAGE SHARED:',
                          style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: ListView.builder(
                            itemCount: _images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.black.withOpacity(.65),
                                elevation: 12,
                                child: CachedNetworkImage(
                                  memCacheHeight: 400,
                                  imageUrl:
                                      '${AppPath.domain}/${_images[index]['url']}',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                        const Text('Loading Image...')
                                      ],
                                    );
                                  },
                                  errorWidget: (context, object, stacktrace) {
                                    return const Icon(Icons.error);
                                  },
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
                            onPressed: () async {
                              await onPickImage();
                            },
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
    // attempt to get location first
    Position position = await getLocation();

    Provider.of<AppStateManager>(context, listen: false).addPosition(position);
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: quality);
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
