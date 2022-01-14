import 'dart:async';
import 'dart:convert';
import 'editprofile.dart';
import 'package:swash/toasty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swash/models/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// A function that converts a response body into a List<Photo>.
List<GetProfile> parseProfile(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetProfile>((json) => GetProfile.fromJson(json)).toList();
}

Future<List<GetProfile>> fetchProfile(
    http.Client client, String? userId) async {
  final response = await client.post(
    Uri.parse('http://trueapps.org/swash/apis/get_profile.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {'user_id': userId},
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return parseProfile(response.body);
}

// Future<dynamic> getProfile(String? userId) async {
//   final response = await http.post(
//     Uri.parse('http://trueapps.org/swash/apis/get_profile.php'),
//     headers: { "Content-Type": "application/x-www-form-urlencoded" },
//     encoding: Encoding.getByName('utf-8'), body: { 'user_id': userId },
//   );
//   if (response.statusCode == 200) { return json.decode(response.body);
//   } else {
//     return Toasty().show('Somethings went wrong.', Toast.LENGTH_SHORT);
//   }
// }

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<GetProfile> _profile;
  final _storage = const FlutterSecureStorage();

  init() async {
    var userId = await _storage.read(key: "user_id");
    fetchProfile(http.Client(), userId);
  }

  @override
  void initState() {
    init();
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
              icon: Icon(Icons.arrow_back)),
          title: Text('Profile'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 100.0),
          child: FutureBuilder<GetProfile>(
            future: _profile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: .5)),
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50.0,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey[800],
                                    size: 100.0,
                                  ))),
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
                                                EditProfile()));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20.0,
                                  )))
                        ],
                      ),
                      const Text('Mbagala primary',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          Text('Mbagala kizuiani',
                              style: TextStyle(color: Colors.blue))
                        ],
                      ),
                      const Divider(),
                      const Text('Mbagala Primary School',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('0715308271'),
                      const Text('Mbagala-Dar es salaam'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              4, (index) => const Icon(Icons.star))),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0)),
                          onPressed: null,
                          child: const Text(
                            'School Manager',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                    ]);
              } else {
                return const Text('Data not found.');
              }
            },
          ),
        ));
  }
}


// {
//   "success":true,
//   "profile":{
//     "id":"72",
//     "name":"juma",
//     "role_id":"3",
//     "email":"juma@gmail.com",
//     "profile_pic":null,
//     "gender":"o",
//     "bio":"",
//     "location":"kawe",
//     "category_name":null,
//     "is_expert":"0",
//     "ambassador_level":null,
//     "school":null,
//     "ward":null
//   }
// }
