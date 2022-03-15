import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class PostCard extends StatefulWidget {
  final snap;
  PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
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

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: GestureDetector(
              /* onTap: () {
                print(widget.snap['uid']);
              }, */
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
                      borderRadius: BorderRadius.circular(340.0),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(340.0),
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
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
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
                                        .toList(),
                                  ),
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
                Hero(
                  tag: widget.snap['postUrl'],
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
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
                      Icons.favorite,
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
            children: <Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
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
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: TextStyle(
                        color: textColor,
                      ),
                    )),
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
                InkWell(
                  child: Container(
                    child: Text(
                      'View all $commentLen comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
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
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
