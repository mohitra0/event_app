import 'package:flutter/material.dart';

@immutable
class EventCategories{
  final String photoUrl;
  final String title;
  final Color color1, color2;
  final double width, height;

  EventCategories({this.title, this.photoUrl, this.color1, this.color2, this.width, this.height});
}