import 'TextToSpeech.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/initialisation.dart';
import 'mute.dart';
import 'dart:async';

class Home extends StatelessWidget {
  TextToSpeech tts = new TextToSpeech();
  final timeout = const Duration(seconds: 3);

  var go = [
    false,
    false,
    false,
    false
  ]; //0:sos,1:mute,2:initialisation,3:navigation

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
    tts.tellCurrentScreen("Home");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        routes: {
          '/mute': (context) => Mute(),
          '/initialisation': (context) => Initialisation()
        },
        title: "home_trial",
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: new AppBar(
                    title: new Text('Virtual Personal Assistant'),
                    backgroundColor: Color(0xFF1C3BC8),
                  ),
                  body: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (details){
                          tts.tellCurrentScreen("Home");
                    },
                    child:   new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new SizedBox(
                                width: 178.0,
                                height: 312.0,
                                child: new RaisedButton(
                                    key: null,
                                    onPressed: () {
                                      tts.tellPress("SEND  S O S");
                                      _startTimer();
                                      if (goOrNot(0)) {}
                                    },
                                    color: const Color(0xFF266EC0),
                                    child: new Text(
                                      "SEND SOS",
                                      style: new TextStyle(
                                          fontSize: 21.0,
                                          color: const Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto"),
                                    )),
                              ),
                              new Padding(
                                padding: const EdgeInsets.all(0.0),
                              ),
                              new SizedBox(
                                width: 178.0,
                                height: 312.0,
                                child: new RaisedButton(
                                    key: null,
                                    onPressed: () {
                                      tts.tellPress("Mute");
                                      _startTimer();
                                      if (goOrNot(1)) {
                                        Navigator.pushNamed(context, '/mute');
                                      }
                                    },
                                    color: const Color(0xFF00B1D2),
                                    child: new Text(
                                      "MUTE AUDIO",
                                      style: new TextStyle(
                                          fontSize: 21.0,
                                          color: const Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto"),
                                    )),
                              )
                            ]),
                        new Padding(
                          padding: const EdgeInsets.all(0.0),
                        ),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new SizedBox(
                                width: 178.0,
                                height: 312.0,
                                child: new RaisedButton(
                                    key: null,
                                    onPressed: () {
                                      tts.tellPress("Navigation");
                                      _startTimer();
                                      if (goOrNot(3)) {}
                                    },
                                    color: const Color(0xFF00B1D2),
                                    child: new Text(
                                      "NAVIGATION",
                                      style: new TextStyle(
                                          fontSize: 21.0,
                                          color: const Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto"),
                                    )),
                              ),
                              new Padding(
                                padding: const EdgeInsets.all(0.0),
                              ),
                              new SizedBox(
                                width: 178.0,
                                height: 312.0,
                                child: new RaisedButton(
                                    key: null,
                                    onPressed: () {
                                      tts.tellPress("Initialisation");
                                      _startTimer();
                                      if (goOrNot(2)) {
                                        Navigator.pushNamed(
                                            context, '/initialisation');
                                      }
                                    },
                                    color: const Color(0xFF266EC0),
                                    child: new Text(
                                      "INITIALISATION",
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: const Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto"),
                                    )),
                              )
                            ])
                      ])
                  )
                  
                
                )));
  }
}
