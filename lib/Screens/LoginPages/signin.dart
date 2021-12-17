// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:how_you_doin/Utils/theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ListView(
          children: [
            Text(
              "Glad! ",
              style: TextStyle(
                  fontSize: 64, letterSpacing: 2, fontFamily: authenia),
            ),
            Text(
              "You Are here",
              style: TextStyle(
                  fontSize: 64, letterSpacing: 2, fontFamily: authenia),
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                labelText: "NAME",
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
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "SIGN UP ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: library,
                      letterSpacing: 3),
                ),
                style: ElevatedButton.styleFrom(
                    primary: green,
                    maximumSize: Size(width / 3, height / 20),
                    shape: StadiumBorder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
