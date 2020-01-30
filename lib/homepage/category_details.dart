import 'package:admin_app/transitions/slide_top_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/prefs.dart';
import 'event_details.dart';

class CategoryDetails extends StatefulWidget {
  final String category;
  final Color color;

  CategoryDetails({this.category, this.color});

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  Widget gridCache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [widget.color, Colors.white],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              stops: [0.1, 1.0]),
        ),
        child: ListView(
          padding: EdgeInsets.only(bottom: 10.0),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 50.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Prefs().retIOS()
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  widget.category,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .where('category', isEqualTo: widget.category)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapShot) {
                if (snapShot.hasError)
                  return Text('Error: ${snapShot.error}');
                switch (snapShot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white)),
                      ),
                    );
                  default:
                    if (snapShot.data.documents.length == 0) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 200.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Events in this category \n  will come very soon! \n        Stay tuned... 😉',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      );
                    }
                    if (gridCache == null){
                      gridCache = GridView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 9 / 10,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0),
                          children: snapShot.data.documents.map((document) {
                            return SingleEventCategory(
                              title: document['Ename'],
                              photoUrl1: document['Url1'],
                              photoUrl2: document['Url2'],
                              photoUrl3: document['Url3'],
                              photoUrl4: document['Url4'],
                              date: document['Edate'],
                              desc: document['Edesc'],
                              venue: document['venue'],
                              orgn: document['orgn'],
                              index: document['eventID'],
                              fbLink: document['fbLink'],
                              igLink: document['igLink'],
                            );
                          }).toList()
                      );
                    }
                    return gridCache;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class SingleEventCategory extends StatelessWidget {
  final String title,
      photoUrl1,
      photoUrl2,
      photoUrl3,
      photoUrl4,
      date,
      desc,
      venue,
      orgn,
      index,
      fbLink,
      igLink;

  SingleEventCategory(
      {this.title,
      this.photoUrl1,
      this.photoUrl2,
      this.photoUrl3,
      this.photoUrl4,
      this.date,
      this.desc,
      this.venue,
      this.orgn,
      this.index,
      this.igLink,
      this.fbLink});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            SlideTopRoute(
                page: EventDetails(
              title: title,
              photoUrl1: photoUrl1,
              photoUrl2: photoUrl2,
              photoUrl3: photoUrl3,
              photoUrl4: photoUrl4,
              index: index,
              date: date,
              isEventDet: false,
              venue: venue,
              orgn: orgn,
              desc: desc,
            )));
      },
      child: Container(
        height: 150.0,
        width: 100.0,
        child: Card(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: photoUrl1,
                    imageBuilder: (context, imgProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imgProvider, fit: BoxFit.cover)),
                    ),
                    placeholder: (context, val) => Center(
                      child: SpinKitCircle(
                        color: Color(0xFF232b2b),
                        size: 10.0,
                      ),
                    ),
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [Colors.grey.withOpacity(0.0), Colors.black],
                          stops: [0.0, 1.0])),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
