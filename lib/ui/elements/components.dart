import 'package:flutter/material.dart';

Widget appBarText(BuildContext context, String title) {
  return Text(
    title,
    style: TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w700,
    ),
  );
}