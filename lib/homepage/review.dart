import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_bar.dart';
import '../transitions/slide_top_route.dart';
import 'event_details.dart';

class Review extends StatefulWidget {
  final ScrollController controller;

  Review({Key key, this.controller}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Trending',
        isVisible: false,
        isEventDet: false,
        isTrending: true,
      ),
      
      body: Container(
        padding: EdgeInsets.only(top: 15.0, left: 15.0),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: Firestore.instance.collection('events').orderBy('likes', descending: true).where('likes', isGreaterThanOrEqualTo: 10).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
            if (snapShot.hasError) return Text('Error: ${snapShot.error}');
            switch (snapShot.connectionState){
              case ConnectionState.waiting:
                return Center(
                  child: SpinKitCircle(
                    color: Color(0xFF232b2b),
                    size: 50.0,
                  ),
                );
              default:
                return ListView(
                  key: widget.key,
                  controller: widget.controller,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: snapShot.data.documents.map((document){
                    return SingleTrendCard(
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
                      fbLink: document['fbLink'],
                      igLink: document['igLink'],
                    ) as Widget;
                  }).toList()..add(
                    Container(
                      height: 50,
                    )
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class SingleTrendCard extends StatelessWidget {
  final String photoUrl1, photoUrl2, photoUrl3, photoUrl4, title, date, venue, orgn, desc, index, igLink, fbLink;

  SingleTrendCard({
    this.title,
    this.photoUrl1,
    this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.date,
    this.desc,
    this.index,
    this.venue,
    this.orgn,
    this.fbLink,
    this.igLink
  });

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
                    index: index,
                    title: title,
                    photoUrl1: photoUrl1,
                    photoUrl2: photoUrl2,
                    photoUrl3: photoUrl3,
                    photoUrl4: photoUrl4,
                    desc: desc,
                    date: date,
                    venue: venue,
                    orgn: orgn,
                    fbLink: fbLink,
                    igLink: igLink,
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
                      imageUrl: photoUrl1,
                      imageBuilder: (context, imgProvider) => Container(
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
                          size: 20.0,
                        )
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
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      date,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
