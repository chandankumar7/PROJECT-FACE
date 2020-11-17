import 'package:flutter/material.dart';
import 'package:ui_trial/SignUpUser.dart';
import 'homeR.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '360 VPA APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignUpUser());
  }
}
