import 'package:flutter/material.dart';

import '../take_info/image_picker.dart';
import '../utils/background.dart';
import '../utils/prefs.dart';
import '../utils/fade_in.dart';
import '../transitions/slide_left_route.dart';

class FurtherInfo extends StatefulWidget {
  final String name, date, desc, venue;

  FurtherInfo({this.name, this.date, this.desc, this.venue});

  @override
  _FurtherInfoState createState() => _FurtherInfoState();
}

class _FurtherInfoState extends State<FurtherInfo> {
  String formLink, selectedCat, fbLink, igLink;
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scKey = GlobalKey<ScaffoldState>();
  final TextEditingController catController = TextEditingController();

  List<String> catList = [
    'Photography',
    'North East',
    'Fest',
    'Drama',
    'Debate',
    'Music',
    'Enactus',
    'Finance',
    'Street Play',
    'Game events',
    'Technical events',
    'Dance',
    'Women Welfare',
    'Sports',
    'Internship',
    'NSS',
    'Other Events'
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scKey,
      body: Stack(
        children: <Widget>[
          WavyHeader(),
          Padding(
            padding: EdgeInsets.only(top: 70.0, left: 10.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                      Prefs().retIOS()
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Product Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Need ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(text: 'to know more :)'),
                      ]),
                )
              ],
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: fKey,
                child: Column(
                  children: <Widget>[
                    FadeIn(
                      delay: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 55.0, top: MediaQuery.of(context).size.height / 5, right: 20.0),
                        child: TextFormField(
                          controller: catController,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Category',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          onTap: () async{
                            String selected = await showGeneralDialog<String>(
                                barrierColor: Colors.black.withOpacity(0.5),
                                context: context,
                                transitionBuilder: (context, a1, a2, widget){
                                  return Transform.scale(
                                    scale: a1.value,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0)
                                          ),
                                          title: Center(child: Text('Select Category')),
                                          children: catList.map((value){
                                            return Align(
                                              alignment: Alignment.center,
                                              child: new SimpleDialogOption(
                                                onPressed: (){
                                                  Navigator.pop(context, value);
                                                },
                                                child: Text(value.toString()),
                                              ),
                                            );
                                          }).toList()
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 200),
                                barrierDismissible: true,
                                barrierLabel: "",
                                pageBuilder: (context, anim1, anim2){}
                            );
                            if (selected != null){
                              catController.text = selected;
                            }
                          },
                          onSaved: (value) => selectedCat = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                      delay: 1.33,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Join link',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            helperText: 'Link to join your event',
                            fillColor: Color(0xff434343),
                          ),
                          onSaved: (value) => formLink = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                      delay: 1.66,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Facebook page link',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          onSaved: (value) => fbLink = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                      delay: 1.99,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff434343)),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Instagram page link',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          onSaved: (value) => igLink = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                        delay:  2.2,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                            child: InkWell(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                if (fKey.currentState.validate()){
                                  fKey.currentState.save();
                                  Navigator.push(context,
                                      SlideLeftRoute(
                                          page: ImagePicker(
                                            name: widget.name,
                                            date: widget.date,
                                            desc: widget.desc,
                                            venue: widget.venue,
                                            formLink: formLink,
                                            igLink: igLink,
                                            category: selectedCat,
                                            fbLink: fbLink,
                                          )
                                      ));
                                }
                                else{
                                  Prefs().showInSnackBar('Please fix the errors in red before submitting.', scKey, context);
                                }
                              },
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x80000000),
                                        blurRadius: 30.0,
                                        offset: Offset(0.0, 30.0)
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff434343),
                                        Color(0xff000000),
                                      ]
                                  ),
                                ),
                                child: Center(
                                  child: Text('Continue',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            )
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}