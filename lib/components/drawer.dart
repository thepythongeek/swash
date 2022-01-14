import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/auth/login_form.dart';
import 'package:swash/Screens/voter/userprofile.dart';
import 'package:swash/Screens/auth/school_register.dart';
import 'package:swash/Screens/auth/ward_register.dart';
import 'package:swash/components/components.dart';
import 'package:swash/components/search_people.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/pages.dart';
import 'package:swash/object/follow.dart';
import '../Screens/expert.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  void initState() {
    getFollowers(
        userId: Provider.of<ProfileManager>(context, listen: false).user!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return Drawer(
        child: Container(
      color: Colors.blue,
      child: ListView(
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: .6)),
                        child: Consumer<ProfileManager>(
                            builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfile()));
                            },
                            child: createProfile(
                                path: profileManager.user!.profile == null
                                    ? null
                                    : profileManager.user!.profile!.profilePic,
                                radius: 50),
                          );
                        })),
                    if (profileManager.user!.profile != null)
                      Text(profileManager.user!.profile!.name)
                  ])),
          Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder<String>(
                      future: getFollowers(userId: profileManager.user!.id),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.data}'),
                            );
                          } else {
                            String number = snapshot.data!;
                            return Text('$number Followers');
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })),
                  FutureBuilder<String>(
                      future: getFollowers(
                          userId: profileManager.user!.id, followers: false),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.data}'),
                            );
                          } else {
                            String number = snapshot.data!;
                            return Text('$number Following');
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })),
                ],
              )),
          Container(
              color: Colors.white,
              child: ListTile(
                  title: const Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    profileManager.logout();
                    appStateManager.goto(MyPages.voter, false);
                  })),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 20.0, 10, 0),
              child: Column(children: [
                ListTile(
                  title: const Text(
                    'My Profile',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Search Expert',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: () async {
                    var result = await showSearch(
                        useRootNavigator: true,
                        context: context,
                        delegate: CustomSearch(hinttext: 'Search people'));
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2.0,
                ),
                if (profileManager.user!.role == 'admin')
                  ListTile(
                    title: const Text(
                      'School',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SchoolRegister()));
                    },
                  ),
                if (profileManager.user!.role == 'admin')
                  ListTile(
                    title: const Text(
                      'Ward',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WardRegister()));
                    },
                  ),
                if (profileManager.user!.role == 'admin')
                  ListTile(
                      title: const Text('Prizes',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrizeForm()));
                      }),
                ListTile(
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Terms and Conditions',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    'Rate App',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: () {},
                )
              ])),
        ],
      ),
    ));
  }
}
