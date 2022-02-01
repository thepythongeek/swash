import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/Chat/chatlist.dart';

import 'package:swash/models/models.dart';

class BottomBarState extends StatefulWidget {
  const BottomBarState({Key? key}) : super(key: key);

  @override
  _BottomBarStateState createState() => _BottomBarStateState();
}

class _BottomBarStateState extends State<BottomBarState> {
  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    return BottomNavigationBar(
        currentIndex: appStateManager.currentTab,
        onTap: (i) {
          setState(() {
            appStateManager.toTab(i);

            if (i == 0) {
              switch (profileManager.user!.role) {
                case "voter":
                  appStateManager.goto(MyPages.community, false);
                  appStateManager.goto(MyPages.voter, true);
                  break;
                case "teacher":
                  appStateManager.goto(MyPages.school, true);
                  break;
                default:
              }
            } else if (profileManager.user!.role == "voter" && i == 1) {
              appStateManager.goto(MyPages.voter, false);
              appStateManager.goto(MyPages.community, true);
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
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          if (profileManager.user!.role != 'teacher')
            const BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Jamii'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: 'Message',
          ),
        ]);
  }
}

enum BottomNavPages { home, message, community }
