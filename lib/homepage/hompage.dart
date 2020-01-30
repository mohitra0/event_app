import 'package:admin_app/homepage/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';
import 'search.dart';
import 'add_event.dart';
import 'review.dart';
import '../utils/prefs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var sp;
  int currentPage = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  ScrollController controller = new ScrollController();

  GlobalKey bottomNavigationKey = GlobalKey();
  DateTime currentBackPressTime;

  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    getPreferences();
    pages=[
      Home(key: PageStorageKey('Home'), controller: controller),
      Search(key: PageStorageKey('Search')),
      AddEvent(key: PageStorageKey('Add')),
      Review(key: PageStorageKey('Rating')),
      Profile(key: PageStorageKey('Profile')),

    ];
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print('Out of the app!');
    }
  }

  getPreferences() async {
    sp = await Prefs().getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            PageStorage(
              child: getPage(currentPage),
              bucket: bucket,
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: CurvedNavigationBar(
                key: bottomNavigationKey,
                color: Color(0xFF000000),
                height: 60.0,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeOutCubic,
                animationDuration: Duration(milliseconds: 400),
                items: <Widget>[
                  Icon(Icons.home, color: Colors.white),
                  Icon(FontAwesomeIcons.search, color: Colors.white),
                  Icon(FontAwesomeIcons.plus, color: Colors.white),
                  Icon(Icons.trending_up, color: Colors.white),
                  Icon(Icons.person_pin, color: Colors.white)
                ],
                onTap: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
//              child: Container(color: Colors.red,),
            )
          ],
        ),
//        bottomNavigationBar:
      ),
    );
  }

  getPage(int currentPage) {
//    switch (currentPage) {
//      case 0:
//        return Home(key: PageStorageKey('Home'), controller: controller);
//        break;
//      case 1:
//        return Search(key: PageStorageKey('Search'));
//        break;
//      case 2:
//        return AddEvent(key: PageStorageKey('Add'));
//        break;
//      case 3:
//        return Review(key: PageStorageKey('Rating'));
//        break;
//      case 4:
//        return AboutUs(key: PageStorageKey('AboutUs'));
//        break;
//      default:
//        return null;
//    }
  return pages[currentPage];
  }

  Future<bool> _onWillPopScope() {
    if (currentPage >= 1 && currentPage <= 4) {
      setState(() => currentPage = 0);
      final CurvedNavigationBarState navBarState =
          bottomNavigationKey.currentState;
      navBarState.setPage(0);
    } else {
      if (controller.offset > 0.0) {
        controller.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      } else {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Press again to exit');
          return Future.value(false);
        }
        return Future.value(true);
      }
    }
  }
}
