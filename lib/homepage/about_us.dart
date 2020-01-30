import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:expandable/expandable.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';

import '../utils/app_bar.dart';
import '../transitions/slide_left_route.dart';
import 'query.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String aboutUs = "We are using technology to bring all the different cultures of societies on one platform. We are dedicatedly making an impressive web page and mobile app for your society and you can use that webpage to show others who you are. After providing a platform, we are also there during your event's time when you want others to participate in your event.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'About Us',
        isVisible: false,
        isTrending: true,
        isEventDet: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: ExpandablePanel(
              header: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'images/du.jpeg',
                        width: double.infinity,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10.0, top: 2.0),
                        alignment: Alignment.topRight,
                        child: Text(
                          'About Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                          ),
                        ),
                      ),
                    ],
                  )),
              expanded: Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  aboutUs,
                  softWrap: true,
                ),
              ),
              tapHeaderToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: true,
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: ExpandableThemeData(crossFadePoint: 0),
                  ),
                );
              },
            ),
          ),
          Card(
            elevation: 5.0,
            child: ExpandablePanel(
              header: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'images/launcher_icon.jpg',
                        width: double.infinity,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10.0, top: 2.0),
                        alignment: Alignment.topRight,
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                          ),
                        ),
                      ),
                    ],
                  )),
              expanded: Container(
                margin: EdgeInsets.all(10.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Product Sans',
                      fontSize: 16.0
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'DU UNIFY ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '(\"us\", \"we\", or \"our\") operates the application (hereinafter referred to as the \"Service\").\nWe use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, the terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, accessible from official website of ',
                      ),
                      TextSpan(
                        text: 'Du Unify.',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () => UrlLauncher.launch('http://duunify.in/')
                      )
                    ]
                  ),
                )
              ),
              tapHeaderToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: true,
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: ExpandableThemeData(crossFadePoint: 0),
                  ),
                );
              },
            ),
          ),

          Container(
            height: 60.0,
          )
        ],
      ),

      floatingActionButton: FabDialer(
        [
          FabMiniMenuItem.withText(
            Icon(Icons.call),
            Color(0xFF232b2b),
            4.0,
            "Call Us",
            () => UrlLauncher.launch('tel: +919650563590'),
            "Call Us",
              Color(0xFF232b2b),
            Colors.white,
            true
          ),

          FabMiniMenuItem.withText(
              Icon(Icons.message),
              Color(0xFF232b2b),
              4.0,
              "Write Us",
              () => Navigator.push(context, SlideLeftRoute(page: Query())),
              "Write Us",
              Color(0xFF232b2b),
              Colors.white,
              true
          ),
        ],
        Color(0xFF232b2b),
        Icon(Icons.add, color: Colors.white)
      ),
    );
  }
}
