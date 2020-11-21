import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'homeR.dart';
import 'dart:async';
import 'Size_Config.dart';
import 'dart:io' as io;

class Mute extends StatefulWidget {
   io.File jsonFileFace ;
   io.File jsonFileSos ;
   Mute({this.jsonFileFace,this.jsonFileSos });
  @override
  _MuteState createState() => _MuteState(this.jsonFileFace,this.jsonFileSos);
}

class _MuteState extends State<Mute> {
   io.File jsonFileFace ;
   io.File jsonFileSos ;
    _MuteState(this.jsonFileFace,this.jsonFileSos);
  TextToSpeech tts = new TextToSpeech();


  final timeout = const Duration(seconds: 3);

  var go = [
    false,
    false,
    false,
    false,
    false
  ]; //0:muteobs,1:muteele,2:mutelow,3:mutewet,4:unmuteall

  bool goOrNot(int touch) {
    if (go[touch]) {
      go[touch] = false;
      return true;
    } else {
      for (int i = 0; i < 5; i++) {
        if (i == touch)
          go[touch] = true;
        else
          go[i] = false;
      }
    }
    return false;
  }

  void cancelTouch() {
    for (int i = 0; i < 5; i++) go[i] = false;
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
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tts.tellCurrentScreen("Mute");
    return MaterialApp(
        routes: {'/home': (context) => Home(jsonFileFace : jsonFileFace,jsonFileSos: jsonFileSos)},
        title: 'mute_trial',
        home: Builder(
            builder: (context) => Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                  title: new Text('Mute'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta < -20) {
                        tts.tellDateTime();
                      }
                      if (details.primaryDelta > 20)
                        tts.tellCurrentScreen("Mute");
                    },
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("MUTE OBSTACLE");
                            _startTimer();
                            if (goOrNot(0)) {}
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "MUTE OBSTACLE DETECTION",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("MUTE ELEVATED SURFACE");
                            _startTimer();
                            if (goOrNot(1)) {}
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "MUTE ELEVATED SURFACE DETECTION",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("MUTE LOWERED SURFACE");
                            _startTimer();
                            if (goOrNot(2)) {}
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "MUTE LOWERED SURFACE DETECTION",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("MUTE WET SURFACE");
                            _startTimer();
                            if (goOrNot(3)) {}
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "MUTE WET SURFACE DETECTION",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                          height: SizeConfig.safeBlockVertical * 18 - 12.58,
                          width: SizeConfig.safeBlockHorizontal * 100,
                          child: RaisedButton(
                            key: null,
                            onPressed: () {
                              tts.tellPress("UNMUTE ALL");
                              _startTimer();
                              if (goOrNot(4)) {}
                            },
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "UNMUTE ALL",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 22.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                          )),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1.5,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                    ])))));
  }
}
