import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:howyoudoin/utils/colors.dart';

class UserScreens extends StatefulWidget {
  final String userId;
  const UserScreens({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  State<UserScreens> createState() => _UserScreensState();
}

class _UserScreensState extends State<UserScreens> {
  late var userData;
  getFollowers() async {
    userData =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);
    print(userData);
  }

  @override
  void initState() {
    super.initState();
    getFollowers();
    print("here");
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: green,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Trackers",
            style: TextStyle(
              color: green,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [ProfileCard()],
        ));
  }

  Widget ProfileCard() {
    return ListTile();
  }
}
