import 'package:flutter/material.dart';

class Expert extends StatelessWidget {
  const Expert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'swash',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Container(
                padding: EdgeInsets.all(20),
                child: ListView(children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Search People',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: .25)),
                          child: ListTile(
                            leading: Icon(
                              Icons.person,
                              size: 50,
                            ),
                            title: Row(children: [
                              Text('Elisha Homes'),
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                              ),
                            ]),
                            subtitle: Text('Community'),
                            trailing: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(10)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                onPressed: null,
                                child: Text('follow',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          )),
                      Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: .25)),
                          child: ListTile(
                            leading: Icon(
                              Icons.person,
                              size: 50,
                            ),
                            title: Row(children: [
                              Text('Elisha Homes'),
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                              ),
                            ]),
                            subtitle: Text('Community'),
                            trailing: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(10)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                onPressed: null,
                                child: Text('follow',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          ))
                    ],
                  )
                ]))));
  }
}
