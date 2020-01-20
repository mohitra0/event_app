import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:admin_app/transitions/slide_left_route.dart';
import '../utils/prefs.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title, photoUrl;
  final Widget enterPage, child;
  final bool isVisible, isEventDet, isTrending;

  TopBar({
    @required this.title,
    this.enterPage,
    this.child,
    @required this.isVisible,
    this.photoUrl,
    this.isEventDet,
    this.isTrending
  }) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30))
              ),
              elevation: 10.0,
              child: Container(
                width: isVisible ? MediaQuery.of(context).size.width / 1.25 : MediaQuery.of(context).size.width / 1.05,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                  color: Color(0xFF232b2b),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: !isVisible ? 10 : 30),
                    child: Row(
                      children: <Widget>[
                        Visibility(
                          visible: isTrending != null ? !isTrending : !isVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: IconButton(
                              icon: Icon(isEventDet ? Icons.close : (Prefs().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back),
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),

                        Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: isVisible,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                ),
                elevation: 10,
                color: Color(0xFF232b2b),
                child: MaterialButton(
                    height: 50,
                    minWidth: 50,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                    ),
                    onPressed: (){
                      Navigator.push(context, SlideLeftRoute(page: enterPage));
                    },
                    child: photoUrl != null ?
                        CachedNetworkImage(
                          imageUrl: photoUrl,
                          imageBuilder: (context, imgProvider) => Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imgProvider,
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          placeholder: (context, val) =>
                            Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white,),
                              ),
                            ),
                        )
                        : child
                ),
              ),
            ),
          ],
        )
    );
  }
}
