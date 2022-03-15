import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/global_variable.dart';
import 'package:howyoudoin/widgets/loaders.dart';
import 'package:howyoudoin/screens/pictureDetailScreen.dart';
import 'package:howyoudoin/widgets/postCard.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: FittedBox(
                child: Text(
                  "HowYouDoin",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 38,
                    letterSpacing: 1,
                    fontFamily: authenia,
                  ),
                ),
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ScreenLoader(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => PictureDetails(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  );
                },
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
