import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'components.dart';
import '../path.dart';
import '../models/models.dart';

class EnvironmentCard extends StatefulWidget {
  final Environment environment;
  const EnvironmentCard({Key? key, required this.environment})
      : super(key: key);

  @override
  _EnvironmentCardState createState() => _EnvironmentCardState();
}

class _EnvironmentCardState extends State<EnvironmentCard> {
  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final EnvironmentManager environmentManager =
        Provider.of<EnvironmentManager>(context, listen: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                environmentManager.add(widget.environment);
                appStateManager.goto(MyPages.envDetails, true);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // a column and an image
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: CachedNetworkImage(
                      memCacheHeight: 400,
                      imageUrl: widget.environment.imageUrl.startsWith('https')
                          ? widget.environment.imageUrl
                          : '${AppPath.domain}/${widget.environment.imageUrl}',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) {
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
                      fit: BoxFit.cover,
                    ),
                  )),
                  const SizedBox(
                    width: 21,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.environment.locationName,
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.environment.description,
                        softWrap: true,
                      )
                    ],
                  )),
                ],
              ),
            ),
            Row(
              children: [
                Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.environment.status),
                  ),
                ),
                Card(
                  color: Colors.blue,
                  child: SizedBox(
                    width: 35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.environment.timesReported,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
