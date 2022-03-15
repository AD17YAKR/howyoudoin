import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:howyoudoin/screens/profileScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/global_variable.dart';
import 'package:howyoudoin/widgets/loaders.dart';
import 'package:howyoudoin/screens/pictureDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            controller: searchController,
            decoration: const InputDecoration(
                labelText: 'Search for a user...',
                labelStyle: TextStyle(
                  color: textColor,
                )),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: ScreenLoader(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            isNavBar: false,
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(340.0),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(340.0),
                            child: CachedNetworkImage(
                              imageUrl: (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl'],
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
                          child: CachedNetworkImage(
                            imageUrl: (snapshot.data! as dynamic).docs[index]
                                ['photoUrl'],
                          ),
                          radius: 16,
                        ),
                   */
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: ScreenLoader(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(PictureDetails(snap: snap));
                      },
                      child: Hero(
                        tag: snap['postUrl'],
                        child: CachedNetworkImage(
                          imageUrl: (snapshot.data! as dynamic).docs[index]
                              ['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
