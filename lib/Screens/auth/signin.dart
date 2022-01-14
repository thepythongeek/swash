import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:swash/utility/auth.dart';
import '../../models/models.dart' as m;

class Sigin extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        key: ValueKey(m.MyPages.register),
        name: m.MyPages.register,
        child: const Sigin());
  }

  const Sigin({Key? key}) : super(key: key);

  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Sigin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amberAccent,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: Image.asset(
                      'images/swash.JPG',
                      height: 160,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Swash Competition',
                  style: TextStyle(fontSize: 40),
                ),
                const Text(
                  'Authentification',
                  style: TextStyle(fontSize: 40, color: Colors.orange),
                )
              ],
            )),
            FutureBuilder(
                future: Authentication.initialiseFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initialising Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    print(66);
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSignIn = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _isSignIn
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)))),
                onPressed: () async {
                  setState(() {
                    _isSignIn = true;
                  });

                  // call google sigin api
                  User? user =
                      await Authentication.signInWithGoogle(context: context);
                  print(user);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google_logo.png',
                        height: 35,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                )));
  }
}
