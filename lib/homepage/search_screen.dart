import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flappy_search_bar/search_bar_style.dart';

import 'category_details.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<List<Event>> search(String value) async{
    await Future.delayed(Duration(seconds: 2));
    var queryResultSet = [];
    var tempSearchStore = [];

    if (value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length > 0){
      await searchByKey(value).then((QuerySnapshot docs){
        for (int i = 0; i < docs.documents.length; i++){
          setState(() {
            queryResultSet.add(docs.documents[i].data);
          });
        }
      });

      tempSearchStore = [];
      queryResultSet.forEach((element){
        if (element['Ename'].startsWith(capitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    if (tempSearchStore.length == 0) return [];

    return List.generate(tempSearchStore.length, (int index){
      return Event(
        tempSearchStore[index]['Ename'],
        tempSearchStore[index]['Url1'],
        tempSearchStore[index]['Url2'],
        tempSearchStore[index]['Url3'],
        tempSearchStore[index]['Url4'],
        tempSearchStore[index]['Edesc'],
        tempSearchStore[index]['orgn'],
        tempSearchStore[index]['venue'],
        tempSearchStore[index]['Edate'],
        tempSearchStore[index]['eventID'],
        tempSearchStore[index]['igLink'],
        tempSearchStore[index]['fbLink']
      );
    });
  }

  searchByKey(String field){
    return Firestore.instance.collection('events').where('searchKey', isEqualTo: field.substring(0, 1).toUpperCase()).getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SearchBar(
            onSearch: search,
            onItemFound: (Event event, int index){
              return SingleEventCategory(
                title: event.title,
                photoUrl1: event.photoUrl1,
                photoUrl2: event.photoUrl2,
                photoUrl3: event.photoUrl3,
                photoUrl4: event.photoUrl4,
                desc: event.desc,
                index: event.index,
                orgn: event.orgn,
                venue: event.venue,
                date: event.date,
                igLink: event.igLink,
                fbLink: event.fbLink,
              );
            },
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 2.0,
            searchBarStyle: SearchBarStyle(
              borderRadius: BorderRadius.circular(40.0)
            ),
            icon: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.search),
            ),
            placeHolder: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.search,
                      color: Colors.black54,
                      size: 100.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text('Find events you like...',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 25.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            emptyWidget: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.outlined_flag, size: 100.0, color: Colors.black54),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text('No results for your search',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('Try using different keywords',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            loader: Center(
              child: SpinKitCircle(
                color: Colors.black54,
                size: 50.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Event{
  String title, photoUrl1,photoUrl2, photoUrl3, photoUrl4, date, desc, venue, orgn, index, fbLink, igLink;

  Event(
    this.title,
    this.photoUrl1,
    this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.desc,
    this.orgn,
    this.venue,
    this.date,
    this.index,
    this.igLink,
    this.fbLink
  );
}