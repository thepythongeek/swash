import 'package:flutter/material.dart';
import 'package:swash/Screens/community/enviromentalstatus.dart';
import '../../models/models.dart';
import '../../components/components.dart';

class Community extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.community,
        key: ValueKey(MyPages.community),
        child: const Community());
  }

  const Community({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        bottomNavigationBar: const BottomBarState(),
        drawer: const MainDrawer(),
        backgroundColor: const Color(0xffe1f7f7),
        appBar: AppBar(
          title: const Text('SWASH Competition'),
          bottom: const TabBar(
              labelStyle: TextStyle(fontSize: 12),
              labelPadding: EdgeInsets.zero,
              tabs: <Widget>[
                Tab(
                  text: 'EVENTS',
                ),
                Tab(
                  text: 'ENVIRONMENT ISSUES',
                ),
                Tab(
                  text: 'AMBASSADORS',
                )
              ]),
        ),
        body: const TabBarView(
          children: [Updates(), EnvironmentalStatus(), Ambassador()],
        ),
      ),
    );
  }
}
