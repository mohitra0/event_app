import 'package:flutter/material.dart';

class FadeRouteBuilder<T> extends PageRouteBuilder<T>{
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
      transitionDuration: Duration(milliseconds: 1000),
      pageBuilder: (context, anim1, anim2) => page,
      transitionsBuilder: (context, a1, a2, child){
        return FadeTransition(opacity: a1 , child: child);
      }
  );
}