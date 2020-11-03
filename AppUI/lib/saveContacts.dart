import 'package:flutter/material.dart';
import 'package:ui_trial/initialisation.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'dart:async';

class SaveContacts extends StatelessWidget {
  TextToSpeech tts = new TextToSpeech();
  final timeout = const Duration(seconds: 3);

  var go = [false, false, false]; //0:savecon1,1:savecon2,2:savecon3

  bool goOrNot(int touch) {
    if (go[touch]) {
      go[touch] = false;
      return true;
    } else {
      for (int i = 0; i < 3; i++) {
        if (i == touch)
          go[touch] = true;
        else
          go[i] = false;
      }
    }
    return false;
  }

  void cancelTouch() {
    for (int i = 0; i < 3; i++) go[i] = false;
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
    tts.tellCurrentScreen("Save Contacts");
    return MaterialApp(
        routes: {'/initialisation': (context) => Initialisation()},
        title: 'SaveContacts_trial',
        home: Builder(
            builder: (context) => Scaffold(
                  backgroundColor: Color(0xFF00B1D2),
                  appBar: new AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/initialisation'),
                    ),
                    title: new Text('Save Contacts'),
                    backgroundColor: Color(0xFF1C3BC8),
                  ),
                  body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (details){
                          tts.tellCurrentScreen("Save Contacts");
                      },
                     child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new RaisedButton(
                            key: null,
                            onPressed: () {
                              tts.tellPress("SAVE CONTACT 1");
                              _startTimer();
                              if (goOrNot(0)) {}
                            },
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "SAVE CONTACT 1",
                              style: new TextStyle(
                                  fontSize: 36.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            )),
                        new RaisedButton(
                            key: null,
                            onPressed: () {
                              tts.tellPress("SAVE CONTACT 2");
                              _startTimer();
                              if (goOrNot(1)) {}
                            },
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "SAVE CONTACT 2",
                              style: new TextStyle(
                                  fontSize: 36.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            )),
                        new RaisedButton(
                            key: null,
                            onPressed: () {
                              tts.tellPress("SAVE CONTACT 3");
                              _startTimer();
                              if (goOrNot(2)) {}
                            },
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "SAVE CONTACT 3",
                              style: new TextStyle(
                                  fontSize: 36.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            ))
                      ]) )
                  
                  
                 
                )));
  }
}
