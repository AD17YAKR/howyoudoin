import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howyoudoin/models/user.dart' as model;
import 'package:howyoudoin/providers/user_provider.dart';
import 'package:howyoudoin/resources/firestore_methods.dart';
import 'package:howyoudoin/screens/commentsScreen.dart';
import 'package:howyoudoin/screens/profileScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/global_variable.dart';
import 'package:howyoudoin/utils/utils.dart';
import 'package:howyoudoin/widgets/likeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PictureDetails extends StatefulWidget {
  final snap;
  PictureDetails({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PictureDetails> createState() => _PictureDetailsState();
}

class _PictureDetailsState extends State<PictureDetails> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  late String postId;
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.snap['postId'],
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    postId = widget.snap['postId'].toString();
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                width > webScreenSize ? secondaryColor : mobileBackgroundColor,
          ),
          color: mobileBackgroundColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ProfileScreen(
                        uid: widget.snap['uid'],
                        isNavBar: false,
                      ));
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Hero(
                          tag: widget.snap['profImage'].toString(),
                          child: CachedNetworkImage(
                            imageUrl: widget.snap['profImage'].toString(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 10.0,
                                height: 10.0,
                                child: new CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    /* CircleAvatar(
                      radius: 16,
                      child: CachedNetworkImage(
                        imageUrl: widget.snap['profImage'].toString(),
                      ),
                    ), */
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.snap['username'].toString(),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.snap['uid'].toString() == user.uid
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ListView(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          'Delete',
                                        ]
                                            .map(
                                              (e) => InkWell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 16),
                                                    child: Text(e),
                                                  ),
                                                  onTap: () {
                                                    deletePost(
                                                      widget.snap['postId']
                                                          .toString(),
                                                    );
                                                    // remove the dialog box
                                                    Navigator.of(context).pop();
                                                  }),
                                            )
                                            .toList()),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.more_vert),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            // IMAGE SECTION OF THE POST
            GestureDetector(
              onDoubleTap: () {
                FireStoreMethods().likePost(
                  widget.snap['postId'].toString(),
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: double.infinity,
                    child: Hero(
                      tag: widget.snap['postUrl'],
                      child: CachedNetworkImage(
                        imageUrl: widget.snap['postUrl'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      child: Icon(
                        CupertinoIcons.hand_thumbsup,
                        color: Colors.white,
                        size: 100,
                      ),
                      duration: Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(
                          () {
                            isLikeAnimating = false;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // LIKE, COMMENT SECTION OF THE POST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                        icon: widget.snap['likes'].contains(user.uid)
                            ? Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: green,
                              )
                            : Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: textColor,
                              ),
                        onPressed: () => FireStoreMethods().likePost(
                          widget.snap['postId'].toString(),
                          user.uid,
                          widget.snap['likes'],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.comment_outlined,
                        color: textColor,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            postId: widget.snap['postId'].toString(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    DateFormat.yMMMEd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(color: secondaryColor, fontSize: 16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        '${widget.snap['likes'].length} likes',
                        style: TextStyle(color: secondaryColor, fontSize: 16),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        child: Container(
                          child: Text(
                            '$commentLen comments',
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              postId: widget.snap['postId'].toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /* StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: ScreenLoader(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => CommentCard(
                    snap: snapshot.data!.docs[index],
                  ),
                );
              },
            ), */
          ],
        ),
      ),
    );
  }
}
