import 'dart:ui';

import 'package:flutter/material.dart';

Widget comment(
    {required String author, required String content, required String date}) {
  return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            author,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(content),
          const SizedBox(
            height: 5,
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ));
}
