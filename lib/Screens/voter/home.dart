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
  late Future<List> isPrize;
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
    isPrize = prizeInfo();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<List> prizeInfo() async {
    List data = [];
    var isPrize = await isTherePrize();
    data.add(isPrize);
    if (isPrize) {
      data.add(await getPrize());
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: isPrize,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool _isPrize = snapshot.data![0];
            prize = _isPrize;
            return DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                floatingActionButton: prize
                    ? AnimatedButton(
                        animation: animation, prize: snapshot.data![1])
                    : null,
                bottomNavigationBar: const BottomBarState(),
                backgroundColor: Colors.grey[200],
                drawer: const MainDrawer(),
                appBar: AppBar(
                  bottom: const TabBar(
                    labelPadding: EdgeInsets.zero,
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
          if (snapshot.hasError) {
            return Text('${snapshot.data}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
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
