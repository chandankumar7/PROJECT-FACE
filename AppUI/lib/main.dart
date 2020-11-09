import 'package:flutter/material.dart';
import 'SignUpUser.dart';
import 'Size_Config.dart';
import 'homeR.dart';
import 'initialisationR.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '360 VPA APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpUser(),
    );
  }
}
