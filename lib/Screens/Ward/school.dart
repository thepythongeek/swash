import 'package:flutter/material.dart';

class SchoolForm extends StatelessWidget {
  const SchoolForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SWASH',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: FittedBox(
                  child: Text(
                'Mgulani primary School won SWASH Competition',
                softWrap: true,
              )),
            ),
            body: Container(
              color: const Color(0xffe1f7f7),
              // main container to style the page
              child: ListView(
                // This column has two children a container containing an Icon button
                // and another container
                children: [
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                    padding: const EdgeInsets.fromLTRB(5, 50, 5, 20),
                    child: const IconButton(
                      iconSize: 180.0,
                      icon: Icon(Icons.add),
                      onPressed: null,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    padding: EdgeInsets.fromLTRB(25, 2, 25, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // this column has a span of text then a container, more text
                      // and finally a textfield.
                      children: [
                        Text('Mgulani primary School Won SWASH Competition'),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              'Congratulations to Mgulani primary school for being'
                              'the first winner in SWASH Competition 2019 through'
                              ' SWASH APP. Again congratulation for Mbagala primary'
                              'for being the second winner and most innovative in'
                              'best way to practice cleanliness. Thanks for all'
                              'schools for good participation',
                              softWrap: true,
                            )),
                        Text('COMMENTS'),
                        const TextField(
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.send),
                              border: OutlineInputBorder(),
                              labelText: 'Enter your comment here'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
