// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:how_you_doin/Utils/theme.dart';

import 'Screens/LoginPages/homescreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: library, letterSpacing: 3),
          bodyText2: TextStyle(fontFamily: lemonMilk, letterSpacing: 3),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
