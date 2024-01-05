import 'dart:js';

import 'package:flutter/material.dart';
import 'package:moment/database/boxes.dart';
import 'package:moment/pages/detail_moment.dart';
import 'package:moment/pages/home.dart';
import 'package:moment/pages/new_moment.dart';

import 'pages/about.dart';

void main() async {
  // Init Hive
  await Boxes.init();

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/detailMoment': (context) => DetailMoment(),
      '/newMoment': (context) => NewMoment(),
      '/about': (context) => About(),
      '/nothing': (context) => About(),
    },
  ));
}
