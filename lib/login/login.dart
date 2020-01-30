import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/fade_in.dart';
import '../transitions/slide_top_route.dart';
import '../utils/prefs.dart';
import 'package:admin_app/homepage/hompage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false, isConnected = false, cLoading = false;
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final FacebookLogin facebookLogin = new FacebookLogin();
  var sp;

  @override
  void initState() {
    super.initState();
    getPreferences();
    Timer(
      Duration(milliseconds: 500),
      (){
        setState(() => loading = true);
      }
    );
  }

  getPreferences() async{
    sp = await Prefs().getPrefs();
  }

  Future gSignIn() async{
    GoogleSignInAccount googleUser = await googleSignIn.signIn()
        .catchError((onError){
          setState(() => cLoading = false);
          Prefs().showInSnackBar("Something went wrong. Please try again later", sKey, context);
          print(onError.toString());
        });

    if (googleUser != null){
      GoogleSignInAuthentication googleSignInAuthentication = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      final FirebaseUser user =  (await fAuth.signInWithCredential(credential)
          .catchError((e){
            Prefs().showInSnackBar("Something went wrong. Please try again later", sKey, context);
            print(e.toString());
          })).user;

      if (user != null){
        final QuerySnapshot snapshot = await Firestore.instance.collection("users")
            .where("id", isEqualTo: user.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = snapshot.documents;

        if (documents.length == 0){
          Prefs().insert({
            "id": user.uid,
            "Uname": user.displayName,
            "email": user.email,
            "profilePic": user.photoUrl,
            "Ph": user.phoneNumber
          }, user);

          sp.setString('uid', user.uid);
          sp.setString('Uname', user.displayName);
          sp.setString('email', user.email);
          sp.setString('photo', user.photoUrl);
          sp.setString('phNo', user.phoneNumber);
        }
        else{
          sp.setString('uid', documents[0]['id']);
          sp.setString('Uname', documents[0]['Uname']);
          sp.setString('email', documents[0]['email']);
          sp.setString('photo', documents[0]['profilePic']);
          sp.setString('phNo', documents[0]['Ph']);
        }

        setState(() => cLoading = false);
        Fluttertoast.showToast(msg: "Welcome ${user.displayName}");
        Navigator.pushReplacement(context, SlideTopRoute(page: HomePage()));
      }
      else{
        setState(() => cLoading = false);
        Prefs().showInSnackBar("Login failed. Please try again later", sKey, context);
      }
    }
    else{
      setState(() => cLoading = false);
      Prefs().showInSnackBar("Login failed. Please try again later", sKey, context);
    }
  }

  Future fSignIn() async{
    await facebookLogin.logIn(['email', 'public_profile', "user_friends"])
        .then((result) async{
      switch (result.status){
        case FacebookLoginStatus.error:
          setState(() => cLoading = false);
          print("Error = " + result.errorMessage);
          Prefs().showInSnackBar("Something went wrong. Please try again later", sKey, context);
          break;
        case FacebookLoginStatus.cancelledByUser:
          setState(() => cLoading = false);
          Prefs().showInSnackBar("Login failed", sKey, context);
          break;
        case FacebookLoginStatus.loggedIn:
          final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
          final FirebaseUser user = (await fAuth.signInWithCredential(credential)).user;

          if (user != null){
            final QuerySnapshot snapshot = await Firestore.instance.collection("users")
                .where("id", isEqualTo: user.uid)
                .getDocuments();
            final List<DocumentSnapshot> documents = snapshot.documents;

            if (documents.length == 0){
              Prefs().insert({
                "id": user.uid,
                "Uname": user.displayName,
                "email": user.email,
                "profilePic": user.photoUrl,
                "Ph": user.phoneNumber
              }, user);

              sp.setString('uid', user.uid);
              sp.setString('Uname', user.displayName);
              sp.setString('email', user.email);
              sp.setString('photo', user.photoUrl);
              sp.setString('phNo', user.phoneNumber);
            }
            else{
              sp.setString('uid', documents[0]['id']);
              sp.setString('Uname', documents[0]['Uname']);
              sp.setString('email', documents[0]['email']);
              sp.setString('photo', documents[0]['profilePic']);
              sp.setString('phNo', documents[0]['Ph']);
            }

            setState(() => cLoading = false);
            Fluttertoast.showToast(msg: "Welcome ${user.displayName}");
            Navigator.pushReplacement(context, SlideTopRoute(page: HomePage()));
          }
          else{
            setState(() => cLoading = false);
          }
          break;
      }
    })
    .catchError((e){
      print(e);
    });
  }

  void checkConn(bool isGoogle) async{
    setState(() => cLoading = true);
    isConnected = await Prefs().checkConnection();
    if (!isConnected){
      setState(() => cLoading = false);
      showDialog(
          context: context,
          builder: (context){
            return Prefs().retIOS() ?
            CupertinoAlertDialog(
              title: Row(
                children: <Widget>[
                  Icon(Icons.announcement, color: Colors.black87),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('No Connection'),
                  ),
                ],
              ),
              content: Text('Please connect to a network to continue'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK',
                    style: TextStyle(
                        color: Colors.blue
                    ),
                  ),
                )
              ],
            ) :
            AlertDialog(
              title: Row(
                children: <Widget>[
                  Icon(Icons.announcement, color: Colors.black87),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('No Connection'),
                  ),
                ],
              ),
              content: Text('Please connect to a network to continue'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK',
                    style: TextStyle(
                        color: Colors.blue
                    ),
                  ),
                )
              ],
            );
          }
      );
    }
    else{
      isGoogle ? gSignIn() : fSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return Stack(
            children: <Widget>[
              Image.asset('images/back1.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              Visibility(
                  visible: loading,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 2),
                      child: Column(
                        children: <Widget>[
                          FadeIn(
                            delay: 1,
                            child: Shimmer.fromColors(
                              baseColor: Color(0xff18d26e),
                              highlightColor: Color(0xff0eff7e),
                              child: ImageIcon(
                                AssetImage('images/new_logo.png'),
                                color: Color(0xff18d26e),
                                size: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),

                          FadeIn(
                            delay: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: constraints.maxWidth >= 2500 ?
                                  MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 10,
                                  right: 10.0, top: 20),
                              child: Shimmer.fromColors(
                                baseColor: Color(0x18d26e),
                                highlightColor: Color(0xff0eff7e),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      color: Color(0xff18d26e),
                                      width: 90.0,
                                      height: 1.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text('Welcome',
                                        style: TextStyle(
                                            color: Color(0xff18d26e),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xff18d26e),
                                      width: 90.0,
                                      height: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          FadeIn(
                              delay: 1.33,
                              child: Padding(
                                padding: EdgeInsets.only(top: 80.0, left: 50.0, right: 50.0),
                                child: InkWell(
                                  onTap: () async{
                                    checkConn(true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: constraints.maxWidth >= 2500 ?
                                              MediaQuery.of(context).size.width / 6.5 : MediaQuery.of(context).size.width / 15),
                                          child: Image.asset('images/google.png',
                                            width: 30.0,
                                            height: 30.0,
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('Sign in with Google',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),

                          FadeIn(
                              delay: 1.66,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0,
                                    left: constraints.maxWidth >= 2500 ? 50.0 : 20.0, right: constraints.maxWidth >= 2500 ? 50.0 : 20.0),
                                child: InkWell(
                                  onTap: (){
                                    // facebook sign in implementation
                                    checkConn(false);
                                  },
                                  child: Container(
                                    height: 48.0,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Color(0xFF4267B2),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(left: constraints.maxWidth >= 2500 ?
                                                MediaQuery.of(context).size.width / 6.5 : MediaQuery.of(context).size.width / 13),
                                            child: ImageIcon(
                                              AssetImage('images/fb.png'),
                                              color: Colors.white,
                                            )
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('Continue with Facebook',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  )
              ),

              Visibility(
                visible: cLoading,
                child: Center(
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0.9),
                      child: SpinKitCircle(
                        size: 40.0,
                        color: Colors.black54,
                      )
                  ),
                ),
              )
            ],
          );
        },
      )
    );
  }
}


//class Login extends StatefulWidget {
//  @override
//  _LoginState createState() => _LoginState();
//}
//
//class _LoginState extends State<Login>  with SingleTickerProviderStateMixin{
//  var sp;
//  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
//  GlobalKey<FormState> admin_formKey = new GlobalKey<FormState>();
//  GlobalKey<FormState> sAdmin_formKey = new GlobalKey<FormState>();
//
//  final FocusNode myFocusNodeUserLogin = FocusNode();
//  final FocusNode myFocusNodePasswordLogin = FocusNode();
//
//  final FocusNode myFocusNodePassword = FocusNode();
//  final FocusNode myFocusNodeUserName = FocusNode();
//
//  TextEditingController loginUnameController = new TextEditingController();
//  TextEditingController loginPasswordController = new TextEditingController();
//
//  bool _obscureTextLogin = true;
//  bool _obscureTextSignup = true;
//  bool loading = false;
//
//  TextEditingController signupUnameController = new TextEditingController();
//  TextEditingController signupPasswordController = new TextEditingController();
//
//  PageController _pageController;
//  String Uname, pass;
//
//  Color left = Colors.black;
//  Color right = Colors.white;
//
//  @override
//  void dispose() {
//    super.dispose();
//    myFocusNodePassword.dispose();
//    myFocusNodeUserName.dispose();
//    _pageController.dispose();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getPreferences();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown
//    ]);
//
//    _pageController = PageController();
//  }
//
//  getPreferences() async{
//    sp = await Prefs().getPrefs();
//  }
//
//  Widget buildMenuBar(BuildContext context){
//    return Container(
//      width: 300.0,
//      height: 50.0,
//      decoration: BoxDecoration(
//        color: Color(0x552B2B2B),
//        borderRadius: BorderRadius.all(Radius.circular(25.0)),
//      ),
//      child: CustomPaint(
//        painter: TabIndicationPainter(pageController: _pageController),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            Expanded(
//              child: FlatButton(
//                splashColor: Colors.transparent,
//                highlightColor: Colors.transparent,
//                onPressed: _onSignIn,
//                child: Text('Admin',
//                  style: TextStyle(
//                    color: left,
//                    fontSize: 16.0,
//                  ),
//                ),
//              ),
//            ),
//
//            Expanded(
//              child: FlatButton(
//                splashColor: Colors.transparent,
//                highlightColor: Colors.transparent,
//                onPressed: _onSignUp,
//                child: Text('Super Admin',
//                  style: TextStyle(
//                    color: right,
//                    fontSize: 16.0
//                  ),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget buildSignIn(BuildContext context){
//    return Container(
//      padding: EdgeInsets.only(top: 23.0),
//      child: Column(
//        children: <Widget>[
//          Stack(
//            alignment: Alignment.topCenter,
//            overflow: Overflow.visible,
//            children: <Widget>[
//              Card(
//                elevation: 2.0,
//                color: Colors.white,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(8.0)
//                ),
//                child: Container(
//                  width: 300.0,
//                  height: 250.0,
//                  child: Form(
//                    key: admin_formKey,
//                    child: Column(
//                      children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
//                          child: TextFormField(
//                            focusNode: myFocusNodeUserLogin,
//                            controller: loginUnameController,
//                            style: TextStyle(
//                              fontSize: 16.0,
//                              color: Colors.black
//                            ),
//                            decoration: InputDecoration(
//                              border: InputBorder.none,
//                              icon: Icon(FontAwesomeIcons.envelope,
//                                color: Colors.black,
//                                size: 22.0,
//                              ),
//                              hintText: 'Username',
//                              hintStyle: TextStyle(
//                                fontSize: 17.0
//                              )
//                            ),
//                            onSaved: (value) => Uname = value,
//                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
//                          ),
//                        ),
//
//                        Container(
//                          width: 250.0,
//                          height: 1.0,
//                          color: Colors.grey[400],
//                        ),
//
//                        Padding(
//                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
//                          child: TextFormField(
//                            focusNode: myFocusNodePasswordLogin,
//                            controller: loginPasswordController,
//                            obscureText: _obscureTextLogin,
//                            style: TextStyle(
//                              fontSize: 16.0,
//                              color: Colors.black
//                            ),
//                            decoration: InputDecoration(
//                              border: InputBorder.none,
//                              icon: Icon(FontAwesomeIcons.lock,
//                                size: 22.0,
//                                color: Colors.black
//                              ),
//                              hintText: 'Password',
//                              hintStyle: TextStyle(fontSize: 17.0),
//                              suffixIcon: InkWell(
//                                onTap: _toggleLogin,
//                                child: Icon(_obscureTextLogin ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
//                                  size: 15.0,
//                                  color: Colors.black,
//                                ),
//                              )
//                            ),
//                            onSaved: (value) => pass = value,
//                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//
//              Container(
//                margin: EdgeInsets.only(top: 225.0),
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                      color: colors.loginGradientStart,
//                      offset: Offset(1.0, 6.0),
//                      blurRadius: 20.0
//                    ),
//                    BoxShadow(
//                      color: colors.loginGradientEnd,
//                      offset: Offset(1.0, 6.0),
//                      blurRadius: 20.0
//                    )
//                  ],
//                  gradient: LinearGradient(
//                    colors: [
//                      colors.loginGradientEnd,
//                      colors.loginGradientStart
//                    ],
//                    begin: FractionalOffset(0.2, 0.2),
//                    end: FractionalOffset(1.0, 1.0),
//                    stops: [0.0, 1.0],
//                    tileMode: TileMode.clamp
//                  ),
//                ),
//                child: MaterialButton(
//                  onPressed: (){
//                    _submit(admin_formKey);
//                  },
//                  highlightColor: Colors.transparent,
//                  splashColor: colors.loginGradientEnd,
//                  child: Padding(
//                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
//                    child: Text('LOGIN',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 25.0
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//
//          Padding(
//            padding: EdgeInsets.only(top: 10.0),
//            child: FlatButton(
//                onPressed: () {},
//                child: Text(
//                  "Forgot Password?",
//                  style: TextStyle(
//                    decoration: TextDecoration.underline,
//                    color: Colors.white,
//                    fontSize: 16.0
//                  ),
//                )
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  void _submit(GlobalKey<FormState> Form) {
//    final form = Form.currentState;
//
//    if (form.validate()) {
//      form.save();
//      signIn(Form);
//    }
//    else{
//      Prefs().showInSnackBar('Please fix the errors in red before submitting.', scaffoldKey, context);
//    }
//  }
//
//  void signIn(GlobalKey<FormState> f){
//    setState((){
//      loading = true;
//    });
//    if (f.currentState.validate()){
//      f.currentState.save();
//      final db = FirebaseDatabase.instance.reference();
//      print(f == admin_formKey);
//      db.child(f == admin_formKey ? 'admin_users' : 'sAdmin_users').child(Uname).once().then((snapShot){
//        Map<dynamic, dynamic> values = snapShot.value;
//        try{
//          if (values.isNotEmpty){
//            if (Uname == values['Uname'] && pass == values['pass']){
//              sp.setBool('isLoggedIn', true);
//              sp.setString('Uname', Uname);
//              sp.setString('user', f == admin_formKey ? 'admin' : 'sAdmin');
//              Navigator.pushReplacement(context, ScaleRoute(page: HomePage()));
//              setState(() {
//                loading = false;
//              });
//              Fluttertoast.showToast(msg: 'Welcome $Uname');
//            }
//            else{
//              setState(() {
//                loading = false;
//              });
//              Prefs().showInSnackBar('Incorrect password', scaffoldKey, context);
//            }
//          }
//        }
//        catch (e){
//          print(e);
//          setState(() {
//            loading = false;
//          });
//          Prefs().showInSnackBar('Username doesn\'t exist', scaffoldKey, context);
//        }
//      });
//    }
//  }
//
//  Widget buildSignUp(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.only(top: 23.0),
//      child: Column(
//        children: <Widget>[
//          Stack(
//            alignment: Alignment.topCenter,
//            overflow: Overflow.visible,
//            children: <Widget>[
//              Card(
//                elevation: 2.0,
//                color: Colors.white,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(8.0),
//                ),
//                child: Container(
//                  width: 300.0,
//                  height: 250.0,
//                  child: Form(
//                    key: sAdmin_formKey,
//                    child: Column(
//                      children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.only(
//                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
//                          child: TextFormField(
//                            focusNode: myFocusNodeUserName,
//                            controller: signupUnameController,
//                            style: TextStyle(
//                                fontSize: 16.0,
//                                color: Colors.black),
//                            decoration: InputDecoration(
//                              border: InputBorder.none,
//                              icon: Icon(
//                                FontAwesomeIcons.user,
//                                color: Colors.black,
//                              ),
//                              hintText: "Username",
//                              hintStyle: TextStyle(fontSize: 16.0),
//                            ),
//                            onSaved: (value) => Uname = value,
//                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
//                          ),
//                        ),
//                        Container(
//                          width: 250.0,
//                          height: 1.0,
//                          color: Colors.grey[400],
//                        ),
//
//                        Padding(
//                          padding: EdgeInsets.only(
//                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
//                          child: TextFormField(
//                            focusNode: myFocusNodePassword,
//                            controller: signupPasswordController,
//                            obscureText: _obscureTextSignup,
//                            style: TextStyle(
//                                fontSize: 16.0,
//                                color: Colors.black),
//                            decoration: InputDecoration(
//                              border: InputBorder.none,
//                              icon: Icon(
//                                FontAwesomeIcons.lock,
//                                color: Colors.black,
//                              ),
//                              hintText: "Password",
//                              hintStyle: TextStyle(
//                                  fontSize: 16.0),
//                              suffixIcon: GestureDetector(
//                                onTap: _toggleSignup,
//                                child: Icon(
//                                  _obscureTextSignup
//                                      ? FontAwesomeIcons.eye
//                                      : FontAwesomeIcons.eyeSlash,
//                                  size: 15.0,
//                                  color: Colors.black,
//                                ),
//                              ),
//                            ),
//                            onSaved: (value) => pass = value,
//                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 225.0),
//                decoration: new BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                      color: colors.loginGradientStart,
//                      offset: Offset(1.0, 6.0),
//                      blurRadius: 20.0,
//                    ),
//                    BoxShadow(
//                      color: colors.loginGradientEnd,
//                      offset: Offset(1.0, 6.0),
//                      blurRadius: 20.0,
//                    ),
//                  ],
//                  gradient: new LinearGradient(
//                      colors: [
//                        colors.loginGradientEnd,
//                        colors.loginGradientStart
//                      ],
//                      begin: const FractionalOffset(0.2, 0.2),
//                      end: const FractionalOffset(1.0, 1.0),
//                      stops: [0.0, 1.0],
//                      tileMode: TileMode.clamp),
//                ),
//                child: MaterialButton(
//                    highlightColor: Colors.transparent,
//                    splashColor: colors.loginGradientEnd,
//                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                    child: Padding(
//                      padding: const EdgeInsets.symmetric(
//                          vertical: 10.0, horizontal: 42.0),
//                      child: Text(
//                        "LOGIN",
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 25.0),
//                      ),
//                    ),
//                    onPressed: () {
//                      _submit(sAdmin_formKey);
//                    }
//                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: scaffoldKey,
//      body: Stack(
//        children: <Widget>[
//          NotificationListener<OverscrollIndicatorNotification>(
//            onNotification: (overScroll) {
//              overScroll.disallowGlow();
//            },
//            child: SingleChildScrollView(
//              child: Container(
//                width: MediaQuery.of(context).size.width,
//                height: MediaQuery.of(context).size.height >= 775.0 ?
//                MediaQuery.of(context).size.height : 775.0,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [
//                          colors.loginGradientStart,
//                          colors.loginGradientEnd
//                        ],
//                        begin: FractionalOffset(0.0, 0.0),
//                        end: FractionalOffset(1.0, 1.0),
//                        stops: [0.0, 1.0],
//                        tileMode: TileMode.clamp
//                    )
//                ),
//                child: Column(
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(top: 75.0),
//                      child: Image(
//                        width: 250.0,
//                        height: 191.0,
//                        fit: BoxFit.fill,
//                        image: AssetImage('images/login_logo.png'),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(top: 20.0),
//                      child: buildMenuBar(context),
//                    ),
//                    Expanded(
//                      flex: 2,
//                      child: PageView(
//                        controller: _pageController,
//                        onPageChanged: (i){
//                          if (i == 0){
//                            setState(() {
//                              right = Colors.white;
//                              left = Colors.black;
//                            });
//                          }
//                          else if (i == 1){
//                            setState(() {
//                              right = Colors.black;
//                              left = Colors.white;
//                            });
//                          }
//                        },
//                        children: <Widget>[
//                          ConstrainedBox(
//                            constraints: BoxConstraints.expand(),
//                            child: buildSignIn(context),
//                          ),
//                          ConstrainedBox(
//                            constraints: BoxConstraints.expand(),
//                            child: buildSignUp(context),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//
//          Visibility(
//            visible: loading ?? true,
//            child: Center(
//              child: Container(
//                alignment: Alignment.center,
//                color: Colors.white.withOpacity(0.9),
//                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78EC6C)),
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  void _onSignIn() {
//    _pageController.animateToPage(0,
//        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//  }
//
//  void _onSignUp() {
//    _pageController?.animateToPage(1,
//        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//  }
//
//  void _toggleLogin() {
//    setState(() {
//      _obscureTextLogin = !_obscureTextLogin;
//    });
//  }
//
//  void _toggleSignup() {
//    setState(() {
//      _obscureTextSignup = !_obscureTextSignup;
//    });
//  }
//}