import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/initialisationR.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'dart:async';
import 'Size_Config.dart';

class SaveFaces extends StatefulWidget {
  @override
  _SaveFacesState createState() => _SaveFacesState();
}

class _SaveFacesState extends State<SaveFaces> {
  TextToSpeech tts = new TextToSpeech();
  final timeout = const Duration(seconds: 3);

  var go = [false]; //0:saveface

  bool goOrNot(int touch) {
    if (go[touch]) {
      go[touch] = false;
      return true;
    } else {
      for (int i = 0; i < 1; i++) {
        if (i == touch)
          go[touch] = true;
        else
          go[i] = false;
      }
    }
    return false;
  }

  void cancelTouch() {
    for (int i = 0; i < 1; i++) go[i] = false;
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
    tts.tellCurrentScreen("Save Faces");
    return MaterialApp(
        routes: {'/initialisation': (context) => Initialisation()},
        title: 'SaveFaces_trial',
        home: Builder(
            builder: (context) => Scaffold(
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/initialisation'),
                  ),
                  title: new Text('Save Faces'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: Column(children: <Widget>[
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                  Container(
                    height: SizeConfig.safeBlockVertical * 18 - 12.58,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    child: RaisedButton(
                        key: null,
                        onPressed: () {
                          tts.tellPress("SAVE FACES");
                          _startTimer();
                          if (goOrNot(0)) {}
                        },
                        color: const Color(0xFF266EC0),
                        child: new Text(
                          "SAVE FACES",
                          style: new TextStyle(
                              fontSize: 50.0,
                              color: const Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto"),
                        )),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                    width: SizeConfig.safeBlockHorizontal * 100,
                  ),
                ]))));
  }
}
