import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howyoudoin/screens/addPostScreen.dart';
import 'package:howyoudoin/screens/chatScreen.dart';
import 'package:howyoudoin/screens/feedScreen.dart';
import 'package:howyoudoin/screens/profileScreen.dart';
import 'package:howyoudoin/screens/searchScreen.dart';

int webScreenSize = 600;

List<Widget> homeScreenItems = [
  ChatScreen(),
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    isNavBar: true,
  ),
];
