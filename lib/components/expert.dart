import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/components/components.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/follow.dart';
import 'package:swash/object/get_profile.dart';

Widget expert(Map profile, BuildContext context) {
  // print(profile);
  return Container(
      decoration: BoxDecoration(border: Border.all(width: .25)),
      child: /*ListTile(
        leading: createProfile(path: profile['profile_pic'], iconSize: 40),
        title: Row(children: [
          Text(profile['name']),
          if (profile['is_expert'] == '1')
            const Icon(
              Icons.verified,
              color: Colors.blue,
            ),
        ]),
        subtitle: profile['category_name'] != null
            ? Text(profile['category_name'])
            : null,
        trailing: FollowButton(profile: profile),
      )*/
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            createProfile(path: profile['profile_pic'], iconSize: 40),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(profile['name']),
                    if (profile['is_expert'] == '1')
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                if (profile['category_name'] != null)
                  Text(profile['category_name'])
              ],
            ),
            const Spacer(),
            FollowButton(profile: profile)
          ],
        ),
      ));
}

class FollowButton extends StatefulWidget {
  final Map profile;

  const FollowButton({Key? key, required this.profile}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _follow;
  bool _loading = true;
  Profile? _profile;

  @override
  void initState() {
    getProfile(
      widget.profile['id'],
      Provider.of<ProfileManager>(context, listen: false).user!.id,
    ).then((value) {
      if (mounted) {
        setState(() {
          _loading = false;
          _profile = value.profile;
          print(_profile!.name);
          print(_profile!.follower);
          _follow = _profile!.follower! == "follower" ? true : false;
          //_follow = widget.profile['followers'] == "follower" ? true : false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            onPressed: () {
              print(_follow);
              if (_follow) {
                follow(
                        followedId: _profile!.id,
                        userId:
                            Provider.of<ProfileManager>(context, listen: false)
                                .user!
                                .id,
                        follow: false)
                    .then((value) {
                  setState(() {
                    _follow = !_follow;
                  });
                });
              } else {
                follow(
                  followedId: _profile!.id,
                  userId: Provider.of<ProfileManager>(context, listen: false)
                      .user!
                      .id,
                ).then((value) {
                  setState(() {
                    _follow = !_follow;
                  });
                });
              }
            },
            child: Text(_follow ? 'unfollow' : 'follow',
                style: TextStyle(
                  color: Colors.white,
                )));
  }
}
