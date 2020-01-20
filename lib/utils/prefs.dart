import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Prefs{
  var sharedPreferences;
  final db = FirebaseDatabase.instance.reference();

  Future<SharedPreferences> getPrefs() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  bool retIOS() => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  void showInSnackBar(String value, GlobalKey<ScaffoldState> scaffoldKey, BuildContext context){
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        duration: Duration(seconds: 3),
    ));
  }

  void writeDB(String name, String desc, String user, String uname){
    db.reference().child(user == 'admin' ? 'admin_users' : 'sAdmin_users').child(uname).update({
      'Name': name,
      'Desc': desc
    });
  }

  Future<bool> checkConnection() async{
    var conResult = await Connectivity().checkConnectivity();
    return (conResult == ConnectivityResult.mobile || conResult == ConnectivityResult.wifi) ? true : false;
  }

  void insert(Map<String, dynamic> data, FirebaseUser user){
    Firestore.instance.collection("users")
        .document(user.uid)
        .setData(data);
  }
}

class UrlProvider extends ChangeNotifier{
  UrlProvider();

  String url = "";

  void setUrl(String URL){
    url = URL;
    notifyListeners();
  }
}