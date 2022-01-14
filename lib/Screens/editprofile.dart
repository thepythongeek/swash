import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Swash',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            'Add Profile Photo',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          radius: 50.0,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[800],
                            size: 100.0,
                          )),
                      TextButton(
                          onPressed: null,
                          child: Text(
                            'Select photo',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ]),
                    Container(
                        margin: EdgeInsets.only(top: 80.0),
                        child: Column(children: [
                          ElevatedButton(
                              onPressed: null,
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[800])),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))
                        ]))
                  ]),
            )));
  }
}
