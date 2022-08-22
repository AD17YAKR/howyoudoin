import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howyoudoin/providers/user_provider.dart';
import 'package:howyoudoin/responsive/mobileScreenLayout.dart';
import 'package:howyoudoin/responsive/responsiveLayout.dart';
import 'package:howyoudoin/responsive/webScreenLayout.dart';
import 'package:howyoudoin/screens/loginScreen.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:howyoudoin/widgets/loaders.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      
      options: FirebaseOptions(
          apiKey: "AIzaSyDq6raC0VKUiTwAVFN2uKwkrBD-1EgP9s0",
          authDomain: "howyoudoin-b14d0.firebaseapp.com",
          projectId: "howyoudoin-b14d0",
          storageBucket: "howyoudoin-b14d0.appspot.com",
          messagingSenderId: "969774606778",
          appId: "1:969774606778:web:b7ce201d56c17d9f9e1583"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(fontFamily: lemonMilk),
            bodyText2: TextStyle(fontFamily: lemonMilk),
            headline1: TextStyle(fontFamily: lemonMilk),
            headline2: TextStyle(fontFamily: lemonMilk),
            headline3: TextStyle(fontFamily: lemonMilk),
            headline4: TextStyle(fontFamily: lemonMilk),
            headline5: TextStyle(fontFamily: lemonMilk),
            headline6: TextStyle(fontFamily: lemonMilk),
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return /*  AddPostScreen(); */ ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ButtonLoader(24),
              );
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
