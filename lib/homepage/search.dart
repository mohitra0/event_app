import 'package:admin_app/homepage/category_details.dart';
import 'package:admin_app/homepage/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../transitions/slide_top_route.dart';
import 'package:admin_app/utils/categories.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{

  List<EventCategories> event_categories = <EventCategories>[
    EventCategories(
      title: 'Photography',
      photoUrl: 'images/categories/camera.png',
      color1: Color(0xff32c6f4),
      color2: Color(0xffAEE5F7),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'North East',
      photoUrl: 'images/categories/north_east.png',
      color1: Color(0xff8cc540),
      color2: Color(0xffBAEC78),
      width: 150.0,
      height: 150.0
    ),
    EventCategories(
      title: 'Fest',
      photoUrl: 'images/categories/fest.png',
      color1: Color(0xff000000),
      color2: Color(0xff6C6C67),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Drama',
      photoUrl: 'images/categories/drama.png',
      color1: Color(0xff2f2f26),
      color2: Color(0xff696958),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Debate',
      photoUrl: 'images/categories/debate.png',
      color1: Color(0xfffd4642),
      color2: Color(0xffF88481),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Music',
      photoUrl: 'images/categories/music.png',
      color1: Color(0xff00b5f1),
      color2: Color(0xff5AD4FC),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Enactus',
      photoUrl: 'images/categories/enactus.png',
      color1: Color(0xfff1801b),
      color2: Color(0xffF89D4C),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Finance',
      photoUrl: 'images/categories/finance.png',
      color1: Color(0xff40c8f4),
      color2: Color(0xff60d8ff),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Street Play',
      photoUrl: 'images/categories/street_play.png',
      color1: Color(0xfff4bc96),
      color2: Color(0xffF7CCAF),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Game events',
      photoUrl: 'images/categories/game.png',
      color1: Color(0xffed1c24),
      color2: Color(0xffFF7A7F),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Technical events',
      photoUrl: 'images/categories/computer.png',
      color1: Color(0xff222424),
      color2: Color(0xff5d7272),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Dance',
      photoUrl: 'images/categories/dance.png',
      color1: Color(0xffa19590),
      color2: Color(0xffa19590),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Women Welfare',
      photoUrl: 'images/categories/women.png',
      color1: Color(0xff32c6f4),
      color2: Color(0xffAEE5F7),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Sports',
      photoUrl: 'images/categories/camera.png',
      color1: Color(0xff32c6f4),
      color2: Color(0xffAEE5F7),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Internship',
      photoUrl: 'images/categories/internship.png',
      color1: Color(0xfff15d54),
      color2: Color(0xffEF9994),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'NSS',
      photoUrl: 'images/categories/camera.png',
      color1: Color(0xff32c6f4),
      color2: Color(0xffAEE5F7),
      width: 80.0,
      height: 60.0
    ),
    EventCategories(
      title: 'Other Events',
      photoUrl: 'images/categories/camera.png',
      color1: Color(0xff32c6f4),
      color2: Color(0xffAEE5F7),
      width: 80.0,
      height: 60.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isInnerBoxScrolled){
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.all(10.0),
                  title: Material(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, SlideTopRoute(page: SearchScreen()));
                      },
                      child: Container(
                        width: 230,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.search, size: 15.0, color: Color(0xFF232b2b)),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text('Search',
                                  style: TextStyle(
                                    color: Color(0xFF232b2b),
                                    fontSize: 15.0
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  background: Container(
                    color: Color(0xFF232b2b),
                  ),
                ),
            )
          ];
        },
        body: GridView.builder(
          padding: EdgeInsets.only(bottom: 70.0, top: 10.0),
          shrinkWrap: true,
          key: widget.key,
          itemCount: event_categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5
          ),
          itemBuilder: (context, index){
            return SingleCategory(
              title: event_categories[index].title,
              photoUrl: event_categories[index].photoUrl,
              color1: event_categories[index].color1,
              color2: event_categories[index].color2,
              height: event_categories[index].height,
              width: event_categories[index].width,
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SingleCategory extends StatelessWidget {
  final String title;
  final String photoUrl;
  final Color color1, color2;
  final double width, height;

  SingleCategory({@required this.title, @required this.photoUrl, this.color1, this.color2, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, SlideTopRoute(page: CategoryDetails(category: title, color: color1)));
        },
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Container(
                width: 200.0,
                height: 125.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                        colors: [color1, color2],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.5, 1.0]
                    )
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 10.0, top: 15.0),
                alignment: Alignment.centerLeft,
                child: Image.asset(photoUrl,
                  fit: BoxFit.fitHeight,
                  width: width,
                  height: height,
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, right: 5.0),
                  child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}