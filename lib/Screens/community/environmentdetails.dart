import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/environment.dart';
import 'package:swash/models/pages.dart';
import '../../path.dart';

class EnvironmentDetails extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.envDetails,
        key: ValueKey(MyPages.envDetails),
        child: const EnvironmentDetails());
  }

  const EnvironmentDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final Environment environment =
        Provider.of<EnvironmentManager>(context, listen: false).environment!;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                appStateManager.goto(MyPages.envDetails, false);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: ListView(
          // Has an image and a column of two rows( a row of buttons
          // and a row of text and icon) and then more text
          children: [
            Container(
              color: Colors.black.withOpacity(.45),
              child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: CachedNetworkImage(
                    imageUrl: '${AppPath.domain}/${environment.imageUrl}',
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                          const Text('Loading Image...')
                        ],
                      );
                    },
                    errorWidget: (context, object, stacktrace) {
                      return const Icon(Icons.error);
                    },
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.location_on),
                    Text(
                      environment.locationName,
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    )
                  ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Times reported'),
                          Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${environment.timesReported}+'),
                            ),
                          )
                        ],
                      ),
                      Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(environment.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                )),
                          )),
                      InkWell(
                        onTap: () {},
                        child: const Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('View on map',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            )),
                      )
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Review',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Text(
                    environment.description,
                    softWrap: true,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Action Taken',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Text('ajkdksfhosjtowe jsfsklruw iaejrhwotj'),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: .24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COMMENTS',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                              labelText: 'Enter your comment here',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.send)),
                        ),
                        Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: .24)),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Salome Felix'),
                              subtitle: Text('mazingira safi'),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                            Icons.favorite_border_outlined)),
                                    Text('12')
                                  ]),
                            )),
                        Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: .24)),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Salome Felix'),
                              subtitle: Text('mazingira safi'),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                            Icons.favorite_border_outlined)),
                                    Text('12')
                                  ]),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
