import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howyoudoin/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var userData;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  // var tracker=;
  @override
  void initState() {
    super.initState();
    getFollowers();
    print("here");
    print(userId);
  }

  getFollowers() async {
    // userData = FirebaseFirestore.instance.collection('users').doc(userId);
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: Text(
          "Chat Box",
          style: TextStyle(color: green),
        ),
        centerTitle: false,
      ),
      /* body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ScreenLoader(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs,
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
      ), */
    );
  }
}
