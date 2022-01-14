import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/pages.dart';
import '../Screens/auth/auth.dart';

class FrontPage extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.home,
        key: ValueKey(MyPages.home),
        child: const FrontPage());
  }

  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SWASH Competition',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        toolbarHeight: 175.0,
        centerTitle: true,
      ),
      /** 
       *Here the body is a container wrapping a Column, The Column 
       * comprises of 2 Text widgets and 2 Elevated Buttons.
       * **/
      body: Container(
        color: Color(0xff0f0475),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const Text(
              'Join the School Water Sanitation and Hygiene(SWASH) '
              'competition campaign and get to impact positive behaviour '
              'among Tanzanian students with just your vote and much more.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .goto(MyPages.login, true);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Sign In"),
                    Icon(Icons.arrow_forward),
                  ]),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size(400, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AppStateManager>(context, listen: false)
                    .goto(MyPages.register, true);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Register"),
                    Icon(Icons.arrow_forward),
                  ]),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size(400, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
