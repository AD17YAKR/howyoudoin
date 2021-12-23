// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:how_you_doin/Screens/LoginPages/signin.dart';
import 'package:how_you_doin/Utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // String authenia = "Authenia";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 15),
        child: ListView(
          children: [
            SizedBox(
              height: height / 20,
            ),
            Text(
              "How You",
              style: TextStyle(
                fontFamily: authenia,
                fontSize: 108,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "Doin!",
              style: TextStyle(
                fontFamily: authenia,
                fontSize: 108,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: "EMAIL",
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: lemonMilk,
                  letterSpacing: 4,
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: "PASSWORD",
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: lemonMilk,
                  letterSpacing: 4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 30),
              child: GestureDetector(
                onTap: () => Get.snackbar(
                  "Under Construcion",
                  "This page is under construction"),
                child: Text(
                  "Forgot Password",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: lemonMilk,
                      letterSpacing: 2,
                      color: green),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "LOG IN ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: library,
                    letterSpacing: 3),
              ),
              style: ElevatedButton.styleFrom(
                primary: green,
                maximumSize: Size(width / 3, height / 20),
                shape: StadiumBorder(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.face),
              label: Text(
                "LOG IN WITH GOOGLE",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  letterSpacing: 4,
                  fontFamily: library,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  maximumSize: Size(width / 3, height / 20),
                  shape: StadiumBorder()),
            ),
            SizedBox(
              height: height / 25,
            ),
            GestureDetector(
              onTap: () => Get.to(SignUp()),
              child: Text(
                "New Here Come Join Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: lemonMilk,
                  letterSpacing: 2,
                  color: green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
