import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';
import '../../components/components.dart';

class Ward extends StatelessWidget {
  const Ward({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.ward, key: ValueKey(MyPages.ward), child: const Ward());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(),
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
