import 'package:flutter/material.dart';

class PageModel {
  late int id;
  String name = "";
  Color color;
  late dynamic icon;

  PageModel({required this.id, required this.name, required this.icon, required this.color});

  int get getPageId {
    return id;
  }

  String get getPageName {
    return name;
  }

  dynamic get getPageIcon {
    return icon;
  }

  Color get getColor{
    return color;
  }
}
