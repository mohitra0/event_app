import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import '../utils/background.dart';
import '../utils/fade_in.dart';
import '../utils/prefs.dart';

class Query extends StatefulWidget {
  @override
  _QueryState createState() => _QueryState();
}

class _QueryState extends State<Query> {
  String uid, name, cllgName, email, phNo, query;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var sp;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  getPreferences() async{
    sp = await Prefs().getPrefs();
    setState(() {
      uid = sp.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WavyHeader(),
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 30.0),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Write Us',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),

//                    TextSpan(
//                      text: ' us...',
//                      style: TextStyle(
//                        color: Colors.black54,
//                      ),
//                    ),
                  ]
              ),
            ),
          ),

          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TODO: Name
                  FadeIn(
                    delay: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 80.0,
                          top: MediaQuery.of(context).size.height / 5,
                          right: 20.0
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Color(0xff434343)
                          ),
                          fillColor: Color(0xff434343),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) => name = value,
                        validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                      ),
                    ),
                  ),

                  //TODO: College Name
                  FadeIn(
                    delay: 1.66,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.0,
                          top: 40.0,
                          right: 30.0
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: 'College',
                          labelStyle: TextStyle(
                              color: Color(0xff434343)
                          ),
                          fillColor: Color(0xff434343),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) => cllgName = value,
                        validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                      ),
                    ),
                  ),

                  //TODO: Email
                  FadeIn(
                    delay: 1.99,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.0,
                          top: 40.0,
                          right: 30.0
                      ),
                      child: TextFormField(
                        initialValue: email,
                        style: TextStyle(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color(0xff434343)
                          ),
                          fillColor: Color(0xff434343),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => email = value,
                        validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                      ),
                    ),
                  ),

                  //TODO: Phone No
                  FadeIn(
                    delay: 2.2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.0,
                          top: 40.0,
                          right: 30.0
                      ),
                      child: TextFormField(
                        initialValue: phNo,
                        style: TextStyle(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: 'Phone No',
                          labelStyle: TextStyle(
                              color: Color(0xff434343)
                          ),
                          fillColor: Color(0xff434343),
                          helperText: 'We\'ll never share your contact no.'
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => phNo = value,
                        validator: (value) => value.length != 10 ? 'Invalid Phone No' : null,
                      ),
                    ),
                  ),

                  //TODO: Query
                  FadeIn(
                    delay: 2.4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50.0,
                          top: 40.0,
                          right: 30.0
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff434343)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: 'Query',
                          labelStyle: TextStyle(
                              color: Color(0xff434343)
                          ),
                          fillColor: Color(0xff434343),
                          helperText: 'We are happy to help you.'
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        onSaved: (value) => query = value,
                        validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 20.0),
                    child: FadeIn(
                      delay: 2.4,
                      child: GestureDetector(
                        onTap: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            setState(() => isLoading = true);
                            Firestore.instance.collection('queries').document(uid).get().then((docSnap){
                              if (docSnap.exists){
                                Firestore.instance.collection('queries').document(uid).updateData({
                                  'Name': name,
                                  'College': cllgName,
                                  'Phone No': phNo,
                                  'Email': email,
                                  'queries': FieldValue.arrayUnion([
                                    {
                                      'query': query,
                                      'status': 'Submitted'
                                    }
                                  ])
                                });
                              }
                              else{
                              Firestore.instance.collection('queries').document(uid).setData({
                                'Name': name,
                                'College': cllgName,
                                'Phone No': phNo,
                                'Email': email,
                                'queries': FieldValue.arrayUnion([
                                  {
                                    'query': query,
                                    'status': 'Submitted'
                                  }
                                ]),
                              });
                              }
                            });
                            Timer(
                                Duration(seconds: 3),
                                    (){
                                  setState(() => isLoading = false);
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(msg: 'Thanks a bunch for filling that out!', toastLength: Toast.LENGTH_LONG);
                                }
                            );
                          }
                        },
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
                                colors: [Color(0xff000000), Color(0xff434343)],
                                stops: [0.2, 1.0]
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
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

                  Container(
                    height: 30.0,
                  )
                ],
              ),
            ),
          ),

          Visibility(
            visible: isLoading,
            child: Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white.withOpacity(0.9),
                child: SpinKitCubeGrid(
                  color: Colors.black54,
                  size: 40.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
