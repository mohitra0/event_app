import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/background.dart';
import '../utils/fade_in.dart';

class Subscribe extends StatefulWidget {
  final String uid;

  Subscribe({this.uid});

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "", socName = "", college = "", phNo = "", email = "";
  bool loading = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildField(String label, double delay){
    return FadeIn(
      delay: delay,
      child: Padding(
        padding: EdgeInsets.only(left: label == 'Name' ? 80.0 : 50.0,
          top: label == 'Name' ? MediaQuery.of(context).size.height / 5 : 40.0,
          right: label == 'Name' ? 20.0 : 30.0
        ),
        child: TextFormField(
          style: TextStyle(
              color: Color(0xffef629f),
              fontSize: 15
          ),
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffef629f)),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffef629f)),
                borderRadius: BorderRadius.circular(10)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffef629f)),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffef629f)),
                borderRadius: BorderRadius.circular(10)
            ),
            labelText: label,
            labelStyle: TextStyle(
                color: Color(0xffef629f)
            ),
            fillColor: Color(0xffef629f),
          ),
          keyboardType: label == 'Phone No' ? TextInputType.phone : TextInputType.text,
          cursorColor: Color(0xffef629f),
          onSaved: (value){
            switch (label){
              case 'Name':
                name = value;
                break;
              case 'Name of Society':
                socName = value;
                break;
              case 'College':
                college = value;
                break;
              case 'Phone No':
                phNo = value;
                break;
              case 'Email':
                email = value;
                break;
            }
          },
          validator: (value) {
            if (label == 'Name' || label == 'Name of society' || label == 'College' || label == 'Email'){
              if (value.isEmpty){
                return 'Please fill this field';
              }
            }
            else if (label == 'Phone No'){
              if (value.length != 10){
                return 'Invalid phone no';
              }
            }
            return null;
          },
        ),
      ),
    );
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
                  fontSize: 30.0
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Enter ',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),

                  TextSpan(
                    text: 'basic details',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
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
                  buildField('Name', 1),
                  buildField('Name of Society', 1.33),
                  buildField('College', 1.66),
                  buildField('Phone No', 1.99),
                  buildField('Email', 2.2),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 20.0),
                    child: FadeIn(
                      delay: 2.4,
                      child: GestureDetector(
                        onTap: (){
                          if (formKey.currentState.validate()){
                            formKey.currentState.save();
                            setState(() => loading = true);
                            Firestore.instance.collection('forms').document(widget.uid).setData({
                              'Name': name,
                              'Name of society': socName,
                              'College': college,
                              'Phone No': phNo,
                              'Email': email,
                              'Status': 'Submitted'
                            });
                            Timer(
                              Duration(seconds: 3),
                              (){
                                setState(() => loading = false);
                                Navigator.pop(context, 'true');
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
                                colors: [Color(0xffeecda3), Color(0xffef629f)],
                                stops: [0.2, 1.0]
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Get Started',
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
                  )
                ],
              ),
            ),
          ),

          Visibility(
            visible: loading,
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
