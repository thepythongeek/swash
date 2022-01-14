import 'package:flutter/material.dart';

Widget container(Function() onPressed) {
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Add photo'), Icon(Icons.add_a_photo)],
      ),
    ),
  );
}
