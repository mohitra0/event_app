import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/prefs.dart';
import 'package:admin_app/take_info/futher_info.dart';
import 'package:admin_app/transitions/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/background.dart';
import '../utils/fade_in.dart';

class TakeInfo extends StatefulWidget {
  @override
  _TakeInfoState createState() => _TakeInfoState();
}

class _TakeInfoState extends State<TakeInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  String eName, eDesc, eDate, venue;
  final format = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          WavyHeader(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 50.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text('What\'s your...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,

                    ),
                  ),
                ),

//                Text('',
//                  style: TextStyle(
//                      color: Colors.black54,
//                      fontSize: 24
//                  ),
//                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FadeIn(
                      delay: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 55.0, top: MediaQuery.of(context).size.height / 5, right: 20.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
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
                            labelText: 'Name of Event',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          onSaved: (value) => eName = value,
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
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                  color: Color(0xff434343)
                              ),
                              fillColor: Color(0xff434343),
                              helperText: 'Keep it short and precise 😉'
                          ),
                          maxLines: 5,
                          maxLength: 100,
                          onSaved: (value) => eDesc = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                      delay: 1.66,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
                        child: DateTimeField(
                          format: format,
                          validator: (value) => value.toString() == null ? 'Please fill this field' : null,
                          onSaved: (value){
                            eDate = format.format(value);
                            print(eDate);
                          },
                          onShowPicker: (context, currentValue){
                            return showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder: (context, child) => Theme(
                                data: ThemeData(
                                  accentColor: Color(0xFF232b2b),
                                  primaryColor: Color(0xFF232b2b),
                                ),
                                child: child,
                              )
                            );
                          },
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
                            labelText: 'Event Date',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15
                          ),
                        )
                      ),
                    ),

                    FadeIn(
                      delay: 1.99,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, top: 30.0, bottom: MediaQuery.of(context).viewInsets.bottom, right: 30.0),
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
                            labelText: 'Venue',
                            labelStyle: TextStyle(
                                color: Color(0xff434343)
                            ),
                            fillColor: Color(0xff434343),
                          ),
                          onSaved: (value) => venue = value,
                          validator: (value) => value.isEmpty ? 'Please fill this field' : null,
                        ),
                      ),
                    ),

                    FadeIn(
                      delay:  2.2,
                      child: Padding(
                            padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: InkWell(
                              onTap: (){
                                if (formKey.currentState.validate()){
                                  formKey.currentState.save();
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (_) => FurtherInfo(name: eName, desc: eDesc, date: eDate, venue: venue)
                                      ));
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
