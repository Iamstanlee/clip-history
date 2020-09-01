import 'package:cliphistory/pages/home/home.dart';
import 'package:cliphistory/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ClipHistory());
}

class ClipHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clip History',
      home: HomePage(),
      theme: theme,
    );
  }
}
