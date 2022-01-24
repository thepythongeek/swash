import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/get_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static MaterialPage page() {
    return const MaterialPage(
        key: ValueKey(MyPages.splash),
        name: MyPages.splash,
        child: SplashScreen());
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white60,
          child: Center(child: Image.asset('images/swash.JPG')),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    initialise();
    super.didChangeDependencies();
  }

  void initialise() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    Map<String, String> keys = await storage.readAll();
    if (keys.isEmpty) {
      Timer(const Duration(seconds: 1), () {
        Provider.of<AppStateManager>(context, listen: false).initiliase();
        Provider.of<AppStateManager>(context, listen: false)
            .goto(MyPages.home, true);
      });
    } else {
      // login user
      ProfileManager profileManager =
          Provider.of<ProfileManager>(context, listen: false);
      profileManager.addUser(User(id: keys['id']!, role: keys['role']!));
      print(profileManager.user!.id);
      print('22');
      profileManager.loginUser();
      // get user profile if he has one

      GetProfile profile = await getProfile(keys['id']!, "null");

      profileManager.updateprofile(profile.profile);
      print(profileManager.user!.profile!.id);
      Timer(const Duration(seconds: 5), () {
        AppStateManager appStateManager =
            Provider.of<AppStateManager>(context, listen: false);
        appStateManager.initiliase();
        print(keys['role']);
        switch (keys['role']) {
          case "ward":
            appStateManager.goto(MyPages.ward, true);
            break;
          case "voter":
          case "admin":
            appStateManager.goto(MyPages.redirect, true);
            appStateManager.goto(MyPages.login, false);

            break;
          case "teacher":
            appStateManager.goto(MyPages.school, true);
            break;
        }
      });
    }
  }
}
