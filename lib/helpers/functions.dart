import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// takes a percentage of the screens width and return a double of current width
double getWidth(context, {width}) {
  if (width == null) return MediaQuery.of(context).size.width;
  return ((width / 100) * MediaQuery.of(context).size.width);
}

/// takes a percentage of the screens height and return a double of screen height.
double getHeight(context, {height}) {
  if (height == null) return MediaQuery.of(context).size.height;
  return ((height / 100) * MediaQuery.of(context).size.height);
}

String getPng(String png) {
  return 'assets/res/$png.png';
}

String formatDate(DateTime date) {
  return new DateFormat.yMMMMd('en_US').format(date);
}

String formatTime(DateTime time) {
  return new DateFormat.jm().format(time);
}

/// Navigate to a new route by passing a route widget
void push(context, Widget to) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => to));
}

/// replace the current widget with a new route by passing a route widget
void replace(context, Widget to) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => to));
}

/// go back to the previous route
void pop(context, {dynamic result}) {
  Navigator.of(context).pop(result);
}
