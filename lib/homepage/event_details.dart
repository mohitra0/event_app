import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_bar.dart';

class EventDetails extends StatefulWidget {
  final String title, photoUrl1,photoUrl2, photoUrl3, photoUrl4, date, desc, venue, orgn, index;
  final bool isEventDet;

  EventDetails({
    @required this.title,
    @required this.photoUrl1,
    @required this.photoUrl2,
    @required this.photoUrl3,
    @required this.photoUrl4,
    @required this.date,
    @required this.index,
    this.desc,
    this.venue,
    this.orgn,
    this.isEventDet
  });

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with SingleTickerProviderStateMixin{
  double animatedHeight = 0.0;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
      (){
        setState(() {
          animatedHeight = 100.0;
        });
      }
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopBar(
        title: 'Event Details',
        isVisible: false,
        isEventDet: widget.isEventDet,
      ),

      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Stack(
            children: <Widget>[
              CarouselSlider(
                items: [widget.photoUrl1, widget.photoUrl2, widget.photoUrl3, widget.photoUrl4].map((i){
                  return Builder(
                    builder: (context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: CachedNetworkImage(
                          imageUrl: i,
                          fit: BoxFit.cover,
                        )
                      );
                    },
                  );
                }).toList(),
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                pauseAutoPlayOnTouch: Duration(seconds: 5),
                enableInfiniteScroll: true,
              ),

              Positioned(
                right: 30.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 70.0,
                  height: animatedHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                    gradient: LinearGradient(
                      colors: [Color(0xffED8F03), Color(0xffFFB75E)],
                      begin: Alignment(0.0, 1.0),
                      end: Alignment(1.0, 0.0),
                    )
                  ),
                  child: Center(
                    child: Text(widget.date,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
              child: Text(widget.title,
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
            child: Text(widget.desc,
              style: TextStyle(
                fontSize: 18.0
              ),
            )
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 30.0, right: 30.0),
            child: Divider(color: Colors.grey),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Product Sans'),
                    children: <TextSpan>[
                      TextSpan(text: 'Venue:  ',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black
                          )
                      ),
                      TextSpan(text: widget.venue,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black
                        )
                      )
                    ]
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 15.0, right: 5.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontFamily: 'Product Sans'),
                        children: <TextSpan>[
                          TextSpan(text: 'Organised by:  ',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black
                              )
                          ),
                          TextSpan(text: widget.orgn,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black
                              )
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        notchMargin: 4.0,
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Colors.white,
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: Icon(Icons.event, color: Colors.white),
        backgroundColor: Color(0xffFFB75E),
        label: Text('Let\'s Join!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: (){},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}