import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:admin_app/homepage/hompage.dart';
import 'package:admin_app/transitions/fade_in_builder.dart';
import 'login/login.dart';
import 'utils/prefs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Prefs().retIOS() ?
        ChangeNotifierProvider<UrlProvider>(
          create: (_) => UrlProvider(),
          child: CupertinoApp(
            title: 'Du Unify',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        ) :
        ChangeNotifierProvider<UrlProvider>(
          create: (_) => UrlProvider(),
          child: MaterialApp(
            title: 'Du Unify',
            theme: ThemeData(
                primaryColor: Color(0xFF232b2b),
                accentColor: Color(0xFF232b2b),
                accentColorBrightness: Brightness.light,
                fontFamily: 'Product Sans'
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FacebookLogin facebookLogin = new FacebookLogin();

  @override
  void initState() {
    super.initState();
    isSignedIn();
    Timer(
        Duration(seconds: 2),
        (){
          if (isLoggedIn){
            Navigator.pushReplacement(context, FadeRouteBuilder(page: HomePage()));
          }
          else{
            Navigator.pushReplacement(context, FadeRouteBuilder(page: Login()));
          }
        }
    );
  }

  isSignedIn() async{
    isLoggedIn = await googleSignIn.isSignedIn() || await facebookLogin.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    offset: Offset(5.0, 5.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0
                  ),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5.0, -5.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0
                  ),
                ],
              ),
            ),

            Image.asset('images/new_logo.png',
              width: 100.0,
              height: 100.0,
            )
          ],
        )
      ),
    );
  }
}
