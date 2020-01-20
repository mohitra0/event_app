import 'dart:io';
import 'dart:async';

import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/background.dart';
import 'package:admin_app/homepage/hompage.dart';
import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/prefs.dart';
import 'package:admin_app/transitions/slide_top_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePicker extends StatefulWidget {
  final String name, desc;

  ImagePicker({this.name, this.desc});

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> with LoadingDelegate{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String currentSelected = "", uname, URL = "";
  List images;
  bool loading = false;
  var sp, imageDataPath = {};

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  getPreferences() async{
    sp = await Prefs().getPrefs();
  }

  void uploadImages() async{
    int i = 0;
    for (var pic in images){
      await _addImages(File(pic), i);
      i++;
    }
    setState(() => loading = false);
  }

  Future<Null> _addImages(File file, int i) async{
    final StorageReference ref = FirebaseStorage.instance.ref().child('users/$uname/img${i+1}');
    StorageUploadTask task = ref.putFile(file);

    await task.onComplete.then((taskSnapShot) async{
      URL = await taskSnapShot.ref.getDownloadURL();
      imageDataPath['image${i+1}'] = URL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          WavyHeader(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        icon: Icon(Prefs().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text('Pick ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                        ),
                      ),
                    ),
  
                    Text(' ' + 'some images...',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24
                      ),
                    )
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    images == null ?
                        Container(
                          height: 300.0,
                          width: 400.0,
                          child: Icon(
                            Icons.image,
                            size: 250.0,
                            color: Colors.grey,
                          ),
                        ) :
                        SizedBox(
                          height: 300.0,
                          width: 400.0,
                          child: ListView.builder(
                            itemCount: images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Image.file(
                                  File(images[index].toString())
                                ),
                              )
                          ),
                        ),
                    GestureDetector(
                      onTap: (){
                        uname = sp.getString('Uname');
                        setState(() => loading = true);
                        if (images == null){
                          setState(() => loading = false);
                          Prefs().showInSnackBar('No images selected', scaffoldKey, context);
                        }
                        else{
                          uploadImages();
                          Prefs().writeDB(widget.name, widget.desc, sp.getString('user'), uname);
                          sp.setString('name', widget.name);
                          sp.setString('desc', widget.desc);
                          sp.setBool('isReg', true);

                          Timer(
                            Duration(seconds: 3),
                            (){
                              Navigator.pushAndRemoveUntil(context,
                                SlideTopRoute(page: HomePage()),
                                (Route route) => false);
                            }
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
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
                            child: Text('Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 10.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78EC6C)),
                        ),
                      ),

                      Text('Saving your preferences...',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87
                        ),
                      )
                    ],
                  )
                )
              ),
            ),
          )
        ],
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0, right: 10.0),
        child: FloatingActionButton.extended(
          onPressed: (){
            _pickAsset(PickType.onlyImage);
            Fluttertoast.showToast(msg: currentSelected);
          },
          backgroundColor: Color(0xFFFF9844),
          icon: Icon(Icons.add_a_photo, color: Colors.white),
          label: Text('Add'),
        ),
      ),
    );
  }

  @override
  Widget buildBigImageLoading(BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  @override
  Widget buildPreviewLoading(BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  void _pickAsset(PickType type, {List<AssetPathEntity> pathList})async{
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      themeColor: Color(0xFFFF9844),
      textColor: Colors.white,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      maxSelected: 4,
      provider: I18nProvider.english,
      rowCount: 3,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Color(0xFFFF9844)
      ),
      loadingDelegate: this,
      badgeDelegate: DurationBadgeDelegate(),
      pickType: type,
      photoPathList: pathList
    );

    if (imgList == null){
      currentSelected = "No item selected";
    }
    else{
      List<String> r = [];
      for (var e in imgList){
        var file = await e.file;
        r.add(file.absolute.path);
      }

      images = r;
      currentSelected = "${imgList.length} photos selected";
    }
    setState(() {});
  }
}