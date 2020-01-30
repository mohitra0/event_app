import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'subscribe.dart';
import '../utils/fade_in.dart';
import '../utils/prefs.dart';
import '../take_info/take_info.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent>
    with SingleTickerProviderStateMixin {
  double scale;
  AnimationController _animationController;
  bool isVisible = true;
  String uid, status;
  var sp;

  @override
  void initState() {
    super.initState();
    getPreferences();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 1.0
    )
      ..addListener(() {
        setState(() {});
      });
  }

  getPreferences() async {
    sp = await Prefs().getPrefs();
    setState(() {
      uid = sp.getString('uid');
    });
    if (status == null) {
      Firestore.instance.collection('forms').document(uid).get().then((
          document) {
        if (document.exists) {
          if (document['Status'] == 'Approved') {
            setState(() => status = 'Approved');
            sp.setString('status', 'Approved');
            print('get: ' + status);
          }
          else {
            setState((){
              isVisible = false;
              status = 'Submitted';
              sp.setString('status', 'Submitted');
              print(status);
            });
          }
        }
      });
    }
    else{
      setState((){
        status = sp.getString('status');
        isVisible = false;
        print('set: ' + status);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUpSub(TapUpDetails details) async {
    _animationController.reverse();
    String isChanged = await Navigator.push(context, MaterialPageRoute(
        builder: (_) => Subscribe(uid: uid)
    ));

    if (isChanged == 'true') {
      setState(() {
        isVisible = false;
      });
    }
  }

  void _onTapUp(TapUpDetails details){
    _animationController.reverse();
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => TakeInfo()
    ));
  }

  @override
  Widget build(BuildContext context) {
    scale = 1 - _animationController.value;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('images/back1.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),

          Column(
            children: <Widget>[
              FadeIn(
                delay: 1.33,
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 2),
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Image.asset('images/new_logo.png',
                      width: 120.0,
                      height: 120.0,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: MediaQuery
                    .of(context)
                    .size
                    .height / 25),
                child: status == 'Approved' ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeIn(
                          delay: 1.66,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Want to start adding events?'
                                  ),
//                                  TextSpan(
//                                    text: 'NOW!',
//                                    style: TextStyle(
//                                      fontSize: 30.0,
//                                      fontWeight: FontWeight.bold
//                                    )
//                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),

                        FadeIn(
                          delay: 1.99,
                          child: GestureDetector(
                            onTapUp: _onTapUp,
                            onTapDown: _onTapDown,
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white70.withOpacity(
                                          0.2),
                                      blurRadius: 30.0,
                                      offset: Offset(0.0, 30.0),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff434343),
                                        Color(0xff000000)
                                      ],
                                      stops: [0.4, 1.0]
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Tap here!',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                    :
                    Stack(
                      children: <Widget>[
                        Visibility(
                          visible: isVisible,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              children: <Widget>[
                                FadeIn(
                                  delay: 1.66,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'Product Sans',
                                          color: Colors.black
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'The DU Unify platform provides every society of DU to showcase their fest and events in an organized way.',
                                          ),
                                        ]
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: FadeIn(
                                    delay: 2.2,
                                    child: GestureDetector(
                                      onTapUp: _onTapUpSub,
                                      onTapDown: _onTapDown,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          height: 50,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white70.withOpacity(
                                                    0.2),
                                                blurRadius: 30.0,
                                                offset: Offset(0.0, 30.0),
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xff434343),
                                                  Color(0xff000000)
                                                ],
                                                stops: [0.4, 1.0]
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Subscribe now!',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Visibility(
                            visible: !isVisible,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FadeIn(
                                  delay: 1.33,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontFamily: 'Product Sans',
                                              color: Colors.black
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Thank you for connecting with us. ',
                                            ),
                                          ]
                                      ),
                                    ),
                                  )
                                ),

                                FadeIn(
                                  delay: 1.66,
                                  child: Container(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'Product Sans',
                                              color: Colors.black
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Our team shall contact you within\n24 hours.',
                                              ),

                                              TextSpan(
                                                  text: ' Stay tuned.',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  )
                                              )
                                            ]
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}