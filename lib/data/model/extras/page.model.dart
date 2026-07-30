import 'package:flutter/widgets.dart';

class PageModel {
  final String title;
  final String icon;
  final String route;
  final Widget widget;

  PageModel({
    required this.title,
    required this.icon,
    required this.route,
    required this.widget,
  });
}
