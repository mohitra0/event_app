import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';

import '../utils/app_bar.dart';
import 'package:admin_app/homepage/event_details.dart';
import 'package:admin_app/homepage/profile.dart';
import 'package:admin_app/transitions/slide_top_route.dart';
import '../utils/prefs.dart';

class Home extends StatefulWidget {
  final ScrollController controller;

  Home({Key key, this.controller}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>{
  var sp;
  String pic = "", uid = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget listcache;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() async{
    sp = await Prefs().getPrefs();
    setState(() {
      pic = sp.getString('photo');
      uid = sp.getString('uid');
    });
    Provider.of<UrlProvider>(context, listen: false).setUrl(pic);
  }

  @override
  Widget build(BuildContext context) {
    var URL = Provider.of<UrlProvider>(context, listen: false);

    return Scaffold(
        key: scaffoldKey,
        appBar: TopBar(
          title: 'Du Unify',
          child: Icon(Icons.person, color: Colors.white),
          enterPage: Profile(UID: uid),
          isVisible: true,
          isEventDet: false,
          photoUrl: URL.url,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  key: widget.key,
                  stream: Firestore.instance.collection('events').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
                    if (snapShot.hasError) return Text('Error: ${snapShot.error}');
                    switch (snapShot.connectionState){
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF232b2b))
                            ),
                          ),
                        );
                      default:
                        if(listcache == null){
                          listcache = ListView(
                              key: widget.key,
                              controller: widget.controller,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: snapShot.data.documents.map((document){
                                return SingleCard(
                                  title: document['Ename'],
                                  date: document['Edate'],
                                  photoUrl1: document['Url1'],
                                  photoUrl2: document['Url2'],
                                  photoUrl3: document['Url3'],
                                  photoUrl4: document['Url4'],
                                  index: document['eventID'],
                                  desc: document['Edesc'],
                                  venue: document['venue'],
                                  orgn: document['orgn'],
                                  likes: document['likes'],
                                  likeArr: List.castFrom(document['liked_by']),
                                  document: document,
                                  scaffoldKey: scaffoldKey,
                                ) as Widget;
                              }).toList()..add(
                                  Container(
                                    height: 200,
                                  )
                              )
                          );
                        }
                        return listcache;
                    }
                  },
                ),
              )
            ],
          ),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SingleCard extends StatefulWidget {
  final String photoUrl1, photoUrl2, photoUrl3, photoUrl4, title, date, venue, orgn, desc, index;
  final List<String> likeArr;
  final DocumentSnapshot document;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int likes;

  SingleCard({
    @required this.title,
    @required this.photoUrl1,
    @required this.photoUrl2,
    @required this.photoUrl3,
    @required this.photoUrl4,
    @required this.date,
    this.desc,
    this.index,
    this.venue,
    this.orgn,
    this.likes,
    this.likeArr,
    this.document,
    this.scaffoldKey
  });

  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> with AutomaticKeepAliveClientMixin<SingleCard>{
  bool isLike = false, isSaved = false;
  String uid = "";
  int currLikes;
  var sp;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  showFlushBar(){
    Flushbar(
      mainButton: FlatButton(
        child: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onPressed: (){},
      ),
      messageText: Center(
          child: CachedNetworkImage(
            imageUrl: widget.photoUrl1,
            imageBuilder: (context, imgProvider) => Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imgProvider,
                      fit: BoxFit.cover
                  )
              ),
            ),
          )
      ),
      duration: Duration(milliseconds: 1700),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      margin: EdgeInsets.only(left: 140.0, right: 60.0),
      borderRadius: 10.0,
      backgroundColor: Color(0xffeecda3),
    )..show(context);
  }

  getPreferences() async{
    sp = await Prefs().getPrefs();
    setState(() {
      uid = sp.getString('uid');
      currLikes = widget.likes;
    });

    if (widget.likeArr.contains(uid)){
      isLike = true;
    }

    setSaved(true);
  }

  void setSaved(bool isChecked){
    Firestore.instance.collection('saved').document(uid).collection('savedItems').document('${widget.index}')
        .get().then((documentSnapshot){
      if (documentSnapshot.exists){
        if (isChecked){
          setState(() => isSaved = true);
        }
        else{
          if (isSaved){
            showFlushBar();
            Firestore.instance.collection('saved').document(uid).collection('savedItems')
                .document('${widget.index}').updateData({
              'title': widget.title,
              'photoUrl1': widget.photoUrl1,
              'photoUrl2': widget.photoUrl2,
              'photoUrl3': widget.photoUrl3,
              'photoUrl4': widget.photoUrl4,
              'date': widget.date,
              'eventID': widget.index,
              'desc': widget.desc,
              'venue': widget.venue,
              'orgn': widget.orgn
            });
          }
          else{
            Firestore.instance.collection('saved').document(uid).collection('savedItems')
                .document('${widget.index}').delete();
          }
        }
      }
      else{
        if (!isChecked){
          showFlushBar();
          Firestore.instance.collection('saved').document(uid).collection('savedItems')
              .document('${widget.index}').setData({
            'title': widget.title,
            'photoUrl1': widget.photoUrl1,
            'photoUrl2': widget.photoUrl2,
            'photoUrl3': widget.photoUrl3,
            'photoUrl4': widget.photoUrl4,
            'date': widget.date,
            'eventID': widget.index,
            'desc': widget.desc,
            'venue': widget.venue,
            'orgn': widget.orgn
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      height: MediaQuery.of(context).size.width / 1.2,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              SlideTopRoute(
                  page: EventDetails(
                    isEventDet: true,
                    index: widget.index,
                    title: widget.title,
                    photoUrl1: widget.photoUrl1,
                    photoUrl2: widget.photoUrl2,
                    photoUrl3: widget.photoUrl3,
                    photoUrl4: widget.photoUrl4,
                    desc: widget.desc,
                    date: widget.date,
                    venue: widget.venue,
                    orgn: widget.orgn,
                  )
              )
          );
        },
        child: Card(
            margin: EdgeInsets.only(right: 15.0),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.photoUrl1,
                    imageBuilder: (context, imgProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imgProvider,
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    placeholder: (context, val) => Center(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF232b2b))
                        ),
                      ),
                    ),
                  )
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.grey.withOpacity(0.0),
                              Colors.black
                            ],
                            stops: [
                              0.0,
                              1.0
                            ])),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                      title: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                        widget.date,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  top: 1.0,
                  child: IconButton(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 35.0,
                        color: Colors.white
                    ),
                    onPressed: (){
                      setState(() => isSaved = !isSaved);
                      setSaved(false);
                    },
                  )
                ),

                Positioned(
                  top: 10.0,
                  right: 20.0,
                  child: LikeButton(
                    isLiked: isLike,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                        size: 30.0,
                      );
                    },
                    likeCount: currLikes,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = Colors.white;
                      Widget result;
                      result = Text(count >= 1000 ? (count / 1000).toStringAsFixed(1) + 'k' : text,
                          style: TextStyle(color: color)
                      );
                      return result;
                    },
                    onTap: (bool liked){
                      Completer<bool> completer = new Completer<bool>();
                      if (isLike){
                        setState((){
                          isLike = false;
                          currLikes--;
                        });
                        if (currLikes != -1 && widget.document['liked_by'].contains(uid)){
                          Firestore.instance.collection('events').document('${widget.index}')
                              .updateData({
                            'liked_by': FieldValue.arrayRemove([uid]),
                            'likes': FieldValue.increment(-1)
                          });
                        }
                      }
                      else{
                        setState(() {
                          isLike = true;
                          currLikes++;
                        });
                        if (!widget.document['liked_by'].contains(uid)){
                          print('some2');
                          Firestore.instance.collection('events').document('${widget.index}')
                              .updateData({
                            'liked_by': FieldValue.arrayUnion([uid]),
                            'likes': FieldValue.increment(1)
                          });
                        }
                      }
                      return completer.future;
                    },
                  )
                )
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}