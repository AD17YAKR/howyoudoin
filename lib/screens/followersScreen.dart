import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howyoudoin/utils/colors.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  List<String> followers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Followers"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [ProfileShortCard(context, currentUserUid)],
        ),
      ),
    );
  }

  Widget ProfileShortCard(BuildContext context, String uid) {
    String picUrl =
        "https://firebasestorage.googleapis.com/v0/b/howyoudoin-b14d0.appspot.com/o/profilePics%2FJp9MuHwQAMgNrHujMHGE3sc2C6l2?alt=media&token=db716632-713c-4fc6-8926-e7aaa84f4427";
    // String collections;
    String name = "Prerna Singh";
    return ListTile(
      leading: Container(
        width: 50,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: CachedNetworkImage(
            imageUrl: picUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 10.0,
                height: 10.0,
                child: new CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      trailing: ElevatedButton(
        child: Text("Remove"),
        onPressed: () {
          Get.snackbar("Removed", name + " is Removed from Followers");
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white.withOpacity(.175),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
