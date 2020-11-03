import 'package:flutter/material.dart';
import 'package:ui_trial/SignUpStick.dart';
import 'package:ui_trial/SignUpUser.dart';
import 'package:ui_trial/mute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignUpUser();
  }
}
