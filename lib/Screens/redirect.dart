import 'package:flutter/material.dart';
import 'package:swash/Screens/community/dashboard.dart';
import 'package:swash/Screens/voter/home.dart';
import 'package:swash/models/models.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/pages.dart';

class Dashboard extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.redirect,
        key: ValueKey(MyPages.redirect),
        child: const Dashboard());
  }

  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('SWASH APP '),
      ),
      body: Container(
        width: double.infinity,
        color: Color(0xff0f0475),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Respond to button press
                appStateManager.goto(MyPages.voter, true);
              },
              child: const Text("SWASH COMPETITION",
                  style: TextStyle(fontSize: 19)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(40, 28, 40, 28)),
            ),
            ElevatedButton(
              onPressed: () {
                // Respond to button press
                appStateManager.goto(MyPages.community, true);
              },
              child:
                  const Text("COMMUNITY EVENT", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(40, 28, 40, 28)),
            ),
          ],
        ),
      ),
    );
  }
}
