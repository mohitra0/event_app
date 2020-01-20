import 'package:flutter/material.dart';

class EnterExitSlideRoute extends PageRouteBuilder{
  final Widget enterPage, exitPage;

  EnterExitSlideRoute({this.exitPage, this.enterPage})
    : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) => enterPage,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) =>
          Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0)
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero
                ).chain(CurveTween(curve: Curves.ease)).animate(animation),
                child: enterPage,
              ),
            ],
          )
    );
}