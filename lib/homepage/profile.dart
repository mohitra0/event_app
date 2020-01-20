import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../homepage/event_details.dart';
import '../transitions/slide_left_route.dart';
import '../login/login.dart';
import '../utils/prefs.dart';
import '../transitions/enter_exit_slide.dart';
import '../utils/fade_in.dart';

class Profile extends StatefulWidget {
  final String UID;

  Profile({this.UID});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var sp;
  File _image;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String uid = "",
      uName = "",
      email = "",
      photoUrl = "",
      phoneNo = "",
      newEmail = "",
      newNo = "",
      selected;
  bool loading = false, isEdit = false;
  List<String> selection = ['Camera', 'Gallery'];

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  getPreferences() async {
    sp = await Prefs().getPrefs();
    setState(() {
      uid = sp.getString('uid');
      uName = sp.getString('Uname');
      email = sp.getString('email');
      photoUrl = sp.getString('photo');
      phoneNo = sp.getString('phNo');
    });
  }

  editDialog(bool isEmail) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Prefs().retIOS()
                  ? CupertinoAlertDialog(
                      title: Text(email == null ? "Add" : "Edit"),
                      content: Form(
                        key: isEmail ? _formKey1 : _formKey2,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: isEmail
                                    ? TextInputType.emailAddress
                                    : TextInputType.phone,
                                initialValue: isEmail ? email : phoneNo,
                                validator: (val) {
                                  if (isEmail) {
                                    if (val == "") {
                                      return 'Invalid email';
                                    }
                                  } else {
                                    if (val == "" || val.length != 10) {
                                      return 'Invalid phone no';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  if (isEmail) {
                                    newEmail = val;
                                  } else {
                                    newNo = val;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Add"),
                          onPressed: () {
                            if (isEmail) {
                              if (_formKey1.currentState.validate()) {
                                _formKey1.currentState.save();
                                Navigator.pop(context);
                                if (newEmail != email) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(uid)
                                      .updateData({'email': newEmail});
                                  sp.setString('email', newEmail);
                                  setState(() => email = newEmail);
                                }
                              }
                            } else {
                              if (_formKey2.currentState.validate()) {
                                _formKey2.currentState.save();
                                Navigator.pop(context);
                                if (newNo != phoneNo) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(uid)
                                      .updateData({'Ph': newNo});
                                  sp.setString('phNo', newNo);
                                  setState(() => phoneNo = newNo);
                                }
                              }
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  : AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: Text(email == null ? "Add" : "Edit"),
                      content: Form(
                        key: isEmail ? _formKey1 : _formKey2,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: isEmail
                                    ? TextInputType.emailAddress
                                    : TextInputType.phone,
                                initialValue: isEmail ? email : phoneNo,
                                validator: (val) {
                                  if (isEmail) {
                                    if (val == "") {
                                      return 'Invalid email';
                                    }
                                  } else {
                                    if (val == "" || val.length != 10) {
                                      return 'Invalid phone no';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  if (isEmail) {
                                    newEmail = val;
                                  } else {
                                    newNo = val;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Add"),
                          onPressed: () {
                            if (isEmail) {
                              if (_formKey1.currentState.validate()) {
                                _formKey1.currentState.save();
                                Navigator.pop(context);
                                if (newEmail != email) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(uid)
                                      .updateData({'email': newEmail});
                                  sp.setString('email', newEmail);
                                  setState(() => email = newEmail);
                                }
                              }
                            } else {
                              if (_formKey2.currentState.validate()) {
                                _formKey2.currentState.save();
                                Navigator.pop(context);
                                if (newNo != phoneNo) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(uid)
                                      .updateData({'Ph': newNo});
                                  sp.setString('phNo', newNo);
                                  setState(() => phoneNo = newNo);
                                }
                              }
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: "",
        pageBuilder: (context, animation1, animation2) {});
  }

  Future _takePicture(bool isCamera) async{
    var image = await ImagePicker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

    setState(() => _image = image);
  }

  Future<void> _uploadPicture() async{
    var someUrl = Provider.of<UrlProvider>(context, listen: false);
    setState(() => loading = true);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String URL = "";

    final StorageReference ref = FirebaseStorage.instance.ref().child('users/${user.email}/${user.email}_pic');
    final StorageUploadTask uploadTask = ref.putFile(_image);
    await uploadTask.onComplete.then((taskSnapshot) async{
      URL = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        photoUrl = URL;
        loading = false;
      });
      someUrl.setUrl(photoUrl);
      Firestore.instance.collection('users').document(uid).updateData({'profilePic': photoUrl});
      sp.setString('photo', photoUrl);
    });

  }

  void selectAndUpload(bool isCamera) async{
    await _takePicture(isCamera);
    await _uploadPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                        gradient: LinearGradient(
                          colors: [Color(0xffeecda3), Color(0xffef629f)],
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AvatarGlow(
                              startDelay: Duration(milliseconds: 400),
                              glowColor: Color(0xffFF0000),
                              endRadius: 90.0,
                              duration: Duration(milliseconds: 1200),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: photoUrl,
                                    imageBuilder: (context, imgProvider) => Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imgProvider,
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    ),
                                    placeholder: (context, val) => Container(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 0.0,
                                      right: 1.0,
                                      child: InkWell(
                                        onTap: () async {
                                          Prefs().retIOS()
                                              ? showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoActionSheet(
                                                  title: Text(
                                                      'Select picture from...'),
                                                  actions: <Widget>[
                                                    CupertinoActionSheetAction(
                                                      child: Text('Camera'),
                                                      onPressed: () {
                                                        selectAndUpload(true);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    CupertinoActionSheetAction(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        selectAndUpload(false);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                  cancelButton:
                                                  CupertinoActionSheetAction(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              })
                                              : selected = await showGeneralDialog<String>(
                                              barrierColor: Colors.black.withOpacity(0.5),
                                              context: context,
                                              transitionBuilder: (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: SimpleDialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                      title: Text('Select picture from...'),
                                                      children: selection.map((value) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, value);
                                                          },
                                                          child: Text(value,
                                                            style: TextStyle(
                                                              fontSize: 18.0
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration: Duration(milliseconds: 200),
                                              barrierDismissible: true,
                                              barrierLabel: "",
                                              pageBuilder: (context, anim1, anim2) {}
                                          );
                                          if (selected != null){
                                            if (selected == 'Camera'){
                                              selectAndUpload(true);
                                            }
                                            else{
                                              selectAndUpload(false);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffeecda3),
                                          ),
                                          child:
                                          Icon(Icons.add, color: Colors.white),
                                        ),
                                      ))
                                ],
                              ),
                              shape: BoxShape.circle,
                              animate: true,
                              curve: Curves.fastOutSlowIn,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Row(
                                children: <Widget>[
                                  FadeIn(
                                    delay: 1.33,
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.white, size: 25.0),
                                      onPressed: () {
                                        editDialog(true);
                                      }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Row(
                                children: <Widget>[
                                  FadeIn(
                                    delay: 1.66,
                                    child: Text(
                                      phoneNo == null ? 'Your phone no' : phoneNo,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.white, size: 25.0),
                                      onPressed: () {
                                        editDialog(false);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                    Prefs().retIOS()
                                        ? Icons.arrow_back_ios
                                        : Icons.arrow_back,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              uName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 35.0),
                              child: FloatingActionButton.extended(
                                label: Text(
                                  'Log Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  sp.remove('uid');
                                  sp.remove('Uname');
                                  sp.remove('email');
                                  sp.remove('photo');
                                  sp.remove('phNo');
                                  await googleSignIn.isSignedIn()
                                      ? googleSignIn.signOut()
                                      : FacebookLogin().logOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      EnterExitSlideRoute(
                                          exitPage: Profile(), enterPage: Login()),
                                          (Route route) => false);
                                },
                                icon: Icon(Icons.exit_to_app, color: Colors.white),
                                backgroundColor: Color(0xffeecda3).withOpacity(0.8),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 20.0),
                        child: Text('My Saved Events...',
                          style: TextStyle(
                            color: Color(0xFF232b2b),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                    StreamBuilder(
                      stream: Firestore.instance.collection('saved').document(widget.UID).collection('savedItems').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
                        if (snapShot.hasError) return Text('Error: ${snapShot.error}');
                        switch (snapShot.connectionState){
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF232b2b)),
                              ),
                            );
                          case ConnectionState.none:
                            return Center(child: Text('You don\'t have any saved events'));
                          default:
                            if (snapShot.data.documents.length == 0){
                              return Column(
                                children: <Widget>[
                                  Image.asset('images/robot.png',
                                    width: 200.0,
                                    height: 200.0,
                                  ),

                                  Text('You don\'t have any saved events',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xFF232b2b)
                                    ),
                                  )
                                ],
                              );
                            }
                            return GridView(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              children: snapShot.data.documents.map((document){
                                return SingleSavedEvent(
                                  title: document['title'],
                                  photoUrl1: document['photoUrl1'],
                                  photoUrl2: document['photoUrl2'],
                                  photoUrl3: document['photoUrl3'],
                                  photoUrl4: document['photoUrl4'],
                                  date: document['date'],
                                  index: document['eventID'],
                                  desc: document['desc'],
                                  venue: document['venue'],
                                  orgn: document['orgn']
                                );
                              }).toList(),
                            );
                        }
                      }
                    )
                  ],
                ),
              ),
            ],
          ),

          Visibility(
            visible: loading,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF18D26E)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SingleSavedEvent extends StatelessWidget {
  final String title, photoUrl1,photoUrl2, photoUrl3, photoUrl4, date, desc, venue, orgn, index;

  SingleSavedEvent({
    this.title,
    this.photoUrl1,
    this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.date,
    this.index,
    this.desc,
    this.venue,
    this.orgn
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Color(0xFF232b2b),
        onTap: () => Navigator.push(context,
        SlideLeftRoute(
          page: EventDetails(
            title: title,
            photoUrl1: photoUrl1,
            photoUrl2: photoUrl2,
            photoUrl3: photoUrl3,
            photoUrl4: photoUrl4,
            date: date,
            index: index,
            venue: venue,
            orgn: orgn,
            desc: desc,
            isEventDet: false,
          )
        )
        ),
        child: Card(
          elevation: 0.0,
          child: CachedNetworkImage(
            imageUrl: photoUrl1,
            imageBuilder: (context, imgProvider) => Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imgProvider,
                      fit: BoxFit.cover
                  )
              ),
            ),
            placeholder: (context, val) => Center(
              child: SpinKitCircle(
                color: Color(0xFF232b2b),
                size: 10.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
