import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:howyoudoin/resources/auth_methods.dart';
import 'package:howyoudoin/resources/firestore_methods.dart';
import 'package:howyoudoin/resources/storage_methods.dart';
import 'package:howyoudoin/screens/loginScreen.dart';
import 'package:howyoudoin/screens/pictureDetailScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/utils.dart';
import 'package:howyoudoin/widgets/followButton.dart';
import 'package:howyoudoin/widgets/loaders.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool isNavBar;
  ProfileScreen({
    Key? key,
    required this.uid,
    required this.isNavBar,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  Uint8List? _image;
  TextEditingController _bioController = TextEditingController();

  bool isSelf = false;
  @override
  void initState() {
    super.initState();
    getData();
    isSelf = (FirebaseAuth.instance.currentUser!.uid == widget.uid);
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar

    String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePics', im, false);
    _firestore
        .collection('users')
        .doc(widget.uid)
        .update({"photoUrl": photoUrl});
    print(photoUrl);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(
      () {
        isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: ScreenLoader(),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: widget.isNavBar
                      ? SizedBox()
                      : IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                  backgroundColor: Colors.amber,
                  expandedHeight: 240,
                  flexibleSpace: GestureDetector(
                    onLongPress: () {
                      if (widget.uid == FirebaseAuth.instance.currentUser!.uid)
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                ElevatedButton(
                                  onPressed: selectImage,
                                  child: Text(
                                    "Change Image",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    elevation: 0,
                                    minimumSize: Size(
                                      double.infinity,
                                      50,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                    },
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Hero(
                              tag: userData['photoUrl'],
                              child: CachedNetworkImage(
                                // placeholder: (context, dkw) => ButtonLoader(60),
                                imageUrl: userData['photoUrl'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Hero(
                      tag: userData['photoUrl'],
                      child: Container(
                        color: Colors.amber,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: userData['photoUrl'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                // children:[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Text(
                                    userData['username'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? IconButton(
                                        onPressed: () async {
                                          await AuthMethods().signOut();
                                          Get.offAll(LoginScreen());
                                        },
                                        icon: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.red[300],
                                        ),
                                      )
                                    : isFollowing
                                        ? FollowButtonPlaceHolder(
                                            text: 'Unfollow',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.white,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await FireStoreMethods()
                                                  .followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButtonPlaceHolder(
                                            text: 'Follow',
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              await FireStoreMethods()
                                                  .followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );

                                              setState(
                                                () {
                                                  isFollowing = true;
                                                  followers++;
                                                },
                                              );
                                            },
                                          ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    widget.uid) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: mobileBackgroundColor,
                                        title: Text(
                                          "Update Bio",
                                          style: TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _bioController,
                                              /* decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ), */
                                            )
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_bioController
                                                  .text.isNotEmpty)
                                                _firestore
                                                    .collection('users')
                                                    .doc(widget.uid)
                                                    .update({
                                                  "bio": _bioController.text
                                                });
                                              Get.back();
                                            },
                                            child: Text("Update"),
                                            style: ElevatedButton.styleFrom(
                                              primary: green,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Expanded(
                                child: Text(
                                  userData['bio'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildStatRow(postLen, "Events"),
                                  GestureDetector(
                                      onTap: () {},
                                      child:
                                          buildStatRow(followers, "Followers")),
                                  GestureDetector(
                                      onTap: () {},
                                      child:
                                          buildStatRow(following, "Following")),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ScreenLoader(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 2.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => PictureDetails(
                                  snap: snap,
                                ),
                              );
                            },
                            child: Hero(
                              tag: snap['postUrl'],
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: snap['postUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
  }

  Row buildStatRow(int num, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString() + " ",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
