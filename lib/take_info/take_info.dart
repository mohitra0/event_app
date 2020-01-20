import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/prefs.dart';
import 'package:admin_app/transitions/slide_left_route.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/background.dart';
import '../utils/fade_in.dart';
import 'image_picker.dart';

class TakeInfo extends StatefulWidget {
  @override
  _TakeInfoState createState() => _TakeInfoState();
}

class _TakeInfoState extends State<TakeInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  String name, desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          WavyHeader(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 70.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('What\'s',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(' ' + 'your...',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 24
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: IconButton(
                          icon: Icon(Icons.clear, color: Colors.black54, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15, left: 20),
                width: 300.0,
                height: 410,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      FadeIn(
                        delay: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55.0),
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF9844)),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF9844)),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF9844)),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFF9844)),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  color: Color(0xFFFF9844)
                              ),
                              hintText: 'Society / Organiser name',
                              fillColor: Color(0xFFDDF969),
                            ),
                            onSaved: (value) => name = value,
                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                          ),
                        ),
                      ),

                      FadeIn(
                        delay: 1.33,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF9844)),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF9844)),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF9844)),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF9844)),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    color: Color(0xFFFF9844)
                                ),
                                hintText: 'Tell us something about your self / society',
                                fillColor: Color(0xFFDDF969),
                                helperText: 'Keep it short and precise 😉'
                            ),
                            maxLines: 5,
                            maxLength: 100,
                            onSaved: (value) => desc = value,
                            validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                          ),
                        ),
                      ),

                      FadeIn(delay:  1.66,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                              child: InkWell(
                                onTap: (){
                                  if (formKey.currentState.validate()){
                                    formKey.currentState.save();
                                    Navigator.push(context, SlideLeftRoute(page: ImagePicker(name: name, desc: desc,)));
                                  }
                                  else{
                                    Prefs().showInSnackBar('Please fix the errors in red before submitting.', sKey, context);
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
                                          Color(0xFFFF9844),
                                          Color(0xFFFE8853),
                                          Color(0xFFFD7267),
                                        ]
                                    ),
                                  ),
                                  child: Center(
                                    child: Text('Proceed',
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
            ],
          ),
        ],
      ),
    );
  }
}
