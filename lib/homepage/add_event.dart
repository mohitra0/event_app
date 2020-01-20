import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'subscribe.dart';
import '../utils/fade_in.dart';
import '../utils/prefs.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with SingleTickerProviderStateMixin{
  double scale;
  AnimationController _animationController;
  bool isVisible = true;
  String uid;
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
    )..addListener(() { setState(() {}); });
  }

  getPreferences() async{
    sp = await Prefs().getPrefs();
    setState(() {
      uid = sp.getString('uid');
    });
    Firestore.instance.collection('forms').document(uid).get().then((document){
      if (document.exists){
        setState(() => isVisible = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) async{
    _animationController.reverse();
    String isChanged = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => Subscribe(uid: uid)
    ));

    if (isChanged == 'true'){
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    scale = 1 - _animationController.value;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('images/event_back.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),

          Container(
            color: Color.fromRGBO(0, 0, 0, 0.3),
          ),

          Column(
            children: <Widget>[
              FadeIn(
                delay: 1.33,
                child: Container(
                  padding: EdgeInsets.only(top: 70.0),
                  alignment: Alignment.topCenter,
                  child: Image.asset('images/new_logo.png',
                    width: 120.0,
                    height: 120.0,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
                child: Stack(
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
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Product Sans'
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Showcase your events on ',
                                      ),
                                      TextSpan(
                                          text: 'Du Unify',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    ]
                                ),
                              ),
                            ),

                            FadeIn(
                              delay: 2.0,
                              child: Text('NOW!',
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: FadeIn(
                                delay: 2.2,
                                child: GestureDetector(
                                  onTapUp: _onTapUp,
                                  onTapDown: _onTapDown,
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white70.withOpacity(0.2),
                                            blurRadius: 30.0,
                                            offset: Offset(0.0, 30.0),
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xffeecda3), Color(0xffef629f)],
                                            stops: [0.4, 1.0]
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Subscribe',
                                          style: TextStyle(
                                            fontSize: 30,
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
                            child: Text('Thank you for your response 🙏',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),

                          FadeIn(
                            delay: 1.66,
                            child: Container(
                              padding: EdgeInsets.only(top: 100.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'Product Sans'
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Our team will contact you within\n',
                                    ),

                                    TextSpan(
                                      text: '24 hours.',
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
                    )
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