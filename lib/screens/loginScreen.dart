import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:howyoudoin/resources/auth_methods.dart';
import 'package:howyoudoin/responsive/mobileScreenLayout.dart';
import 'package:howyoudoin/responsive/responsiveLayout.dart';
import 'package:howyoudoin/responsive/webScreenLayout.dart';
import 'package:howyoudoin/screens/signupScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/global_variable.dart';
import 'package:howyoudoin/utils/utils.dart';
import 'package:howyoudoin/widgets/glassMorphism.dart';
import 'package:howyoudoin/widgets/loaders.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isObscured = true;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : EdgeInsets.symmetric(
                  horizontal: 20,
                ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              FittedBox(
                child: Text(
                  "HowYouDoin",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 80,
                    fontFamily: authenia,
                  ),
                ),
              ),
              SizedBox(
                height: 64,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: textColor),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: textColor,
                          fontFamily: lemonMilk,
                          letterSpacing: 2,
                          fontSize: 22,
                        ),
                        fillColor: textColor,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: green,
                            width: 2.0,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp('[ ]'),
                        ),
                      ],
                      cursorColor: green,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      cursorColor: green,
                      controller: _passwordController,
                      style: TextStyle(color: textColor),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: textColor,
                          fontSize: 22,
                        ),
                        fillColor: textColor,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: textColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: green,
                            width: 2.0,
                          ),
                        ),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                          icon: Icon(
                            isObscured
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: green,
                          ),
                        ),
                      ),
                      obscureText: isObscured,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              ElevatedButton(
                onPressed: loginUser,
                child: !_isLoading
                    ? Text(
                        'Log in',
                      )
                    : ButtonLoader(32),
                style: ElevatedButton.styleFrom(
                    primary: green, minimumSize: Size(double.infinity, 45)),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Dont have an account?\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        ' SignUp.\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
