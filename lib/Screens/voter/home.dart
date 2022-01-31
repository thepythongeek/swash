import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:swash/models/models.dart';
import 'package:swash/models/pages.dart';
import 'package:swash/models/prize.dart';
import 'package:swash/object/prize.dart';
import 'dart:math';
import 'vote.dart';
import 'package:flutter/material.dart';

import 'package:swash/components/components.dart';

class Voter extends StatefulWidget {
  const Voter({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: MyPages.voter,
        key: ValueKey(MyPages.voter),
        child: const Voter());
  }

  @override
  State<Voter> createState() => _VoterState();
}

class _VoterState extends State<Voter> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  bool prize = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(seconds: 18),
      vsync: this,
    );
    animation =
        Tween<double>(begin: -360, end: 360).animate(animationController);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: appStateManager.prize != null
            ? AnimatedButton(
                animation: animation, prize: appStateManager.prize!)
            : null,
        bottomNavigationBar: const BottomBarState(),
        backgroundColor: Colors.grey[200],
        drawer: const MainDrawer(),
        appBar: AppBar(
          actions: [
            StreamBuilder<dynamic>(
                stream: appStateManager.channelStream,
                builder: (context, snapshot) {
                  bool alerts;

                  if (snapshot.hasData) {
                    Map<String, dynamic> data = jsonDecode(snapshot.data);
                    print(data);
                    alerts = true;
                  } else {
                    //  ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('${snapshot.data}')));
                    alerts = false;
                  }
                  return BellIcon(alerts: alerts);
                })
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.all(9),
            tabs: [
              Text(
                'VOTE',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'RESULT',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'EVENTS',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'AMBASSADORS',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          title: const Text('SWASH Competition'),
        ),
        body: TabBarView(
          children: [
            VotePage(),
            const Results(),
            const Updates(),
            const Ambassador()
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Animation<double> animation;
  final Prize prize;
  const AnimatedButton({Key? key, required this.animation, required this.prize})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) {
          return FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(content: Text(widget.prize.content));
                  });
            },
            backgroundColor: Colors.amber,
            child: Transform.rotate(
                angle: (widget.animation.value / 360) * (2 * pi),
                child: Icon(Icons.ring_volume_rounded)),
          );
        });
  }
}

class BellIcon extends StatefulWidget {
  final bool alerts;
  const BellIcon({Key? key, required this.alerts}) : super(key: key);

  @override
  _BellIconState createState() => _BellIconState();
}

class _BellIconState extends State<BellIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.notifications,
      color: widget.alerts ? Colors.white : Colors.blue,
    );
  }
}
