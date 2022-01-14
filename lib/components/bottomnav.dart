import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/Chat/chatlist.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/models.dart';
import '../Screens/redirect.dart';

class BottomBarState extends StatefulWidget {
  const BottomBarState({Key? key}) : super(key: key);

  @override
  _BottomBarStateState createState() => _BottomBarStateState();
}

class _BottomBarStateState extends State<BottomBarState> {
  int currentindex = 1;
  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    return BottomNavigationBar(
        currentIndex: currentindex,
        onTap: (i) {
          setState(() {
            currentindex = i;

            if (i == 1) {
              appStateManager.goto(MyPages.redirect, true);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatList(
                            userId: profileManager.user!.id,
                          )));
            }
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: 'message',
          ),
        ]);
  }
}
