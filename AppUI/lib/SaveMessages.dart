import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/initialisation.dart';

import 'home.dart';
import 'initialisation.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'dart:async';

class SaveMessages extends StatelessWidget {
  TextToSpeech tts = new TextToSpeech();
  final timeout = const Duration(seconds: 3);

  var go = [
    false,
    false,
    false,
    false,
  ]; //0:recosos,1:recisos,2:recofall,3:recifall

  bool goOrNot(int touch) {
    if (go[touch]) {
      go[touch] = false;
      return true;
    } else {
      for (int i = 0; i < 4; i++) {
        if (i == touch)
          go[touch] = true;
        else
          go[i] = false;
      }
    }
    return false;
  }

  void cancelTouch() {
    for (int i = 0; i < 4; i++) go[i] = false;
  }

  void _startTimer() {
    Timer _timer;
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      cancelTouch();
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tts.tellCurrentScreen("Save Message");
    return MaterialApp(
      routes: {'/home': (context) => Home()},
      title: 'SaveMessages_trial',
      home: Builder(
          builder: (contaxt) => Scaffold(
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                  title: new Text('Save Message'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (details){
                          tts.tellCurrentScreen("Save Messages");
                      },
                      child:  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RECORD S O S MESSAGE");
                            _startTimer();
                            if (goOrNot(0)) {}
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RECORD SOS MESSAGE",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 29.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RECITE S O S MESSAGE");
                            _startTimer();
                            if (goOrNot(1)) {}
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RECITE SOS MESSAGE",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 29.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RECORD USER FALL MESSAGE");
                            _startTimer();
                            if (goOrNot(2)) {}
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RECORD USER - FALL MESSAGE",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 29.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RECITE USER FALL MESSAGE");
                            _startTimer();
                            if (goOrNot(3)) {}
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RECITE USER - FALL MESSAGE",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 29.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ))
                    ]))
                
                
                
              
              )),
    );
  }
}
