import 'package:flutter/material.dart';
import '../path.dart';
import 'dart:io';

Widget createProfile(
    {String? path, double? radius, double iconSize = 100, network = true}) {
  return CircleAvatar(
    radius: radius,
    child: path != null
        ? network
            ? SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    path.startsWith('https') ? path : '${AppPath.domain}/$path',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    File(path),
                    fit: BoxFit.cover,
                  ),
                ),
              )
        : Icon(
            Icons.person,
            size: iconSize,
          ),
  );
}

Widget profileRow({String? path, String? name, String isverified = "0"}) {
  return Row(
    children: [
      createProfile(path: path),
      const SizedBox(
        width: 10,
      ),
      Text(
        name ?? 'System admin',
        softWrap: true,
      ),
      const SizedBox(
        width: 10,
      ),
      if (isverified == "1")
        const Icon(
          Icons.verified,
          color: Colors.blue,
        )
    ],
  );
}
