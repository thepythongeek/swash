import 'dart:async';
import 'dart:convert';
import 'package:swash/components/components.dart';
import 'package:swash/models/models.dart';

import 'edituserprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../object/get_profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Profile? _profile;
  bool _loading = true;

  @override
  void initState() {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    getProfile(profileManager.user!.id, "null").then((value) {
      setState(() {
        _profile = value.profile;
        _loading = false;
        profileManager.updateprofile(_profile!);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Profile'),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: .5)),
                                child: createProfile(
                                    path: _profile!.profilePic, radius: 80.0)),
                            Container(
                                width: 35.0,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditUserProfile()));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20.0,
                                    )))
                          ],
                        ),
                        Text(_profile!.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark, color: Colors.grey[600]),
                            Text(
                              'Ambassador level:- ${_profile!.ambassadorLevel}',
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            Text(_profile!.location,
                                style: const TextStyle(color: Colors.blue))
                          ],
                        ),
                        if (_profile!.dob != null)
                          Text(_profile!.dob!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        if (_profile!.desr != null)
                          Text(_profile!.desr!, style: TextStyle(fontSize: 18)),
                        Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(_profile!.bio,
                                style: const TextStyle(fontSize: 18))),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0)),
                            onPressed: null,
                            child: Text(
                              Provider.of<ProfileManager>(context,
                                      listen: false)
                                  .user!
                                  .role,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ])));
  }
}
