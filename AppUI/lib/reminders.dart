import 'package:flutter/material.dart';
import 'dart:io' as io;

class reminders extends StatefulWidget {
  io.File jsonFileFace;
  io.File jsonFileSos;
  reminders({this.jsonFileFace, this.jsonFileSos});
  @override
  _remindersState createState() =>
      _remindersState(this.jsonFileFace, this.jsonFileSos);
}

class _remindersState extends State<reminders> {
  io.File jsonFileFace;
  io.File jsonFileSos;
  _remindersState(this.jsonFileFace, this.jsonFileSos);
  @override
  Widget showReminders() {}

  Widget build(BuildContext context) {
    return Container();
  }
}
