import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howyoudoin/screens/addPostScreen.dart';
import 'package:howyoudoin/screens/feedScreen.dart';
import 'package:howyoudoin/screens/profileScreen.dart';
import 'package:howyoudoin/screens/searchScreen.dart';
import 'package:howyoudoin/utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  List<Widget> homeScreenItems = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
      isNavBar: true,
    ),
  ];
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        animationDuration: const Duration(milliseconds: 300),
        height: 55,
        buttonBackgroundColor: green,
        backgroundColor: mobileBackgroundColor.withGreen(85),
        color: mobileBackgroundColor.withRed(1),
        items: <Widget>[
          Icon(
            _page == 0 ? CupertinoIcons.home : CupertinoIcons.home,
            size: 26,
            color: _page == 0 ? Colors.white : green,
          ),
          Icon(
            _page == 1 ? Icons.search : CupertinoIcons.search,
            size: 26,
            color: _page == 1 ? Colors.white : green,
          ),
          _page == 2
              ? Icon(Icons.add_a_photo, size: 26, color: Colors.white)
              : Icon(
                  Icons.add_a_photo_outlined,
                  size: 26,
                  color: green,
                ),
          Icon(
            _page == 3 ? Icons.person : Icons.person_outline,
            size: 26,
            color: _page == 3 ? Colors.white : green,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
