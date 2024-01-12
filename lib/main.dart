import 'package:flutter/material.dart';
import 'package:moment/database/sqflite_database.dart';
import 'package:moment/pages/detail_moment.dart';
import 'package:moment/pages/home.dart';
import 'package:moment/pages/new_moment.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/about.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter services are initialized

  // Instantiate the DatabaseHelper class
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Get a reference to the database
  await databaseHelper.database;

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/detailMoment': (context) => DetailMoment(),
      '/newMoment': (context) => NewMoment(),
      '/about': (context) => About(),
    },
  ));
}
