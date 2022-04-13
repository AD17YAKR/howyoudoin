import 'dart:typed_data';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howyoudoin/widgets/loaders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:howyoudoin/resources/auth_methods.dart';
import 'package:howyoudoin/responsive/mobileScreenLayout.dart';
import 'package:howyoudoin/responsive/responsiveLayout.dart';
import 'package:howyoudoin/responsive/webScreenLayout.dart';
import 'package:howyoudoin/screens/loginScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  bool _isLoading = false;
  Uint8List? _image;
  bool isObscured = true;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    if (_image == null)
      showSnackBar(context, "Select an Image");
    // set loading to true
    else {
      setState(() {
        _isLoading = true;
      });
      // signup user using our authmethodds
      String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          file: _image!);
      // if string returned is sucess, user has been created
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
              height: 16,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: secondaryColor,
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: secondaryColor,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      color: textColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            /* 
            Column(
              children: [ */
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: _usernameController,
                style: TextStyle(color: textColor),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: "UserName",
                  hintStyle: TextStyle(color: textColor, fontSize: 18),
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
              ),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: textColor),
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
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ]),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: _passwordController,
                style: TextStyle(color: textColor, fontSize: 18),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: textColor),
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
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: _bioController,
                style: TextStyle(color: textColor, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Bio",
                  hintStyle: TextStyle(color: textColor),
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
                // maxLines: 4,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            /*  ],
            ), */
            ElevatedButton(
              onPressed: signUpUser,
              child: !_isLoading
                  ? Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    )
                  : ButtonLoader(32),
              style: ElevatedButton.styleFrom(
                  primary: green,
                  minimumSize: Size(
                    double.infinity,
                    50,
                  )),
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
                    'Already have an account?\n',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Container(
                    child: Text(
                      ' Login.\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
