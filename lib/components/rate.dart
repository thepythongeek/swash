import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  final int rating;
  const Rating({Key? key, required this.rating}) : super(key: key);

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    int remaining = 4 - widget.rating;
    return Row(
      children: List.generate(
              widget.rating,
              (index) => Icon(
                    Icons.star,
                  )) +
          List.generate(
              remaining,
              (index) => Icon(
                    Icons.star_border_outlined,
                  )),
    );
  }
}
