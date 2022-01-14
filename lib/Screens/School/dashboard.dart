import 'package:flutter/material.dart';
import '/components/components.dart';
import '../../models/models.dart';
import '../../components/events.dart';

class School extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.school,
        key: ValueKey(MyPages.school),
        child: const School());
  }

  const School({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: const BottomBarState(),
        drawer: const MainDrawer(),
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('SWASH Competition'),
          bottom: const TabBar(tabs: <Widget>[
            Tab(
              text: 'EVENTS',
            ),
            Tab(
              text: 'RESULTS',
            ),
          ]),
        ),
        body: const TabBarView(
          children: [
            Updates(),
            Results(),
          ],
        ),
      ),
    );
  }
}
