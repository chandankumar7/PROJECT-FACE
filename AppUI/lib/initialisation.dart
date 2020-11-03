import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/SaveMessages.dart';
import 'package:ui_trial/saveContacts.dart';
import 'package:ui_trial/saveFaces.dart';
import 'home.dart';
import 'dart:async';
import 'package:ui_trial/TextToSpeech.dart';

class Initialisation extends StatelessWidget {
  TextToSpeech tts = new TextToSpeech();
  
  final timeout = const Duration(seconds: 3);

  var go = [
    false,
    false,
    false,
    false,
  ]; //0:savecon,1:saveface,2:savepmsg,3:reset

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
    tts.tellCurrentScreen("Initialisation");
    return MaterialApp(
      routes: {
        '/home': (context) => Home(),
        '/SaveContacts': (context) => SaveContacts(),
        '/SaveFaces': (context) => SaveFaces(),
        '/SaveSos': (context) => SaveMessages()
      },
      title: 'initialisation_trial',
      home: Builder(
          builder: (context) => Scaffold(
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                  title: new Text('Initialisation'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: GestureDetector(
                   behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (details){
                          tts.tellCurrentScreen("Initialisation");
                      },
                     child:   new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("SAVE CONTACTS");
                            _startTimer();
                            if (goOrNot(0)) {
                              Navigator.pushNamed(context, '/SaveContacts');
                            }
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE CONTACTS",
                            style: new TextStyle(
                                fontSize: 34.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("SAVE FACES");
                            _startTimer();
                            if (goOrNot(1)) {
                              Navigator.pushNamed(context, '/SaveFaces');
                            }
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE FACES",
                            style: new TextStyle(
                                fontSize: 34.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("SAVE PRE DEFINED MESSAGE");
                            _startTimer();
                            if (goOrNot(2)) {
                              Navigator.pushNamed(context, '/SaveSos');
                            }
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE PRE-DEFINED MESSAGE",
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          )),
                      new RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RESET TO DEFAULT");
                            _startTimer();
                            if (goOrNot(3)) {}
                          },
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RESET",
                            style: new TextStyle(
                                fontSize: 34.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ))
                    ])
                )
                
                
                
              
              )),
    );
  }
}
