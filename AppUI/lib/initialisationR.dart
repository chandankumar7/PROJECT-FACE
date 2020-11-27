import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SaveContactsR.dart';
import 'SaveMessagesR.dart';
import 'dart:async';
import 'SaveFacesR.dart';
import 'homeR.dart';
import 'TextToSpeech.dart';
import 'Size_Config.dart';
import 'dart:io' as io;

class Initialisation extends StatefulWidget {
  io.File jsonFileFace;
  io.File jsonFileSos;
  Initialisation({this.jsonFileFace, this.jsonFileSos});
  @override
  _InitialisationState createState() =>
      _InitialisationState(this.jsonFileFace, this.jsonFileSos);
}

class _InitialisationState extends State<Initialisation> {
  io.File jsonFileFace;
  io.File jsonFileSos;

  _InitialisationState(this.jsonFileFace, this.jsonFileSos);

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
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tts.tellCurrentScreen("Initialisation");
    return MaterialApp(
        routes: {
          '/home': (context) =>
              Home(jsonFileFace: jsonFileFace, jsonFileSos: jsonFileSos),
          '/SaveContacts': (context) => SaveContacts(
              jsonFileFace: jsonFileFace, jsonFileSos: jsonFileSos),
          '/SaveFaces': (context) =>
              SaveFaces(jsonFileFace: jsonFileFace, jsonFileSos: jsonFileSos),
          '/SaveSos': (context) =>
              SaveMessages(jsonFileFace: jsonFileFace, jsonFileSos: jsonFileSos)
        },
        title: 'initialisation_trial',
        home: Builder(
            builder: (context) => Scaffold(
                resizeToAvoidBottomPadding: false,
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
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta < -20) {
                        tts.tellDateTime();
                      }
                      if (details.primaryDelta > 20)
                        tts.tellCurrentScreen("Initialisation");
                    },
                    child: Column(children: <Widget>[
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
                            tts.tellPress("SAVE CONTACTS");
                            _startTimer();
                            if (goOrNot(0)) {
                              Navigator.pushNamed(context, '/SaveContacts');
                            }
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE CONTACTS",
                            style: new TextStyle(
                                fontSize: 34.0,
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
                            if (goOrNot(1)) {
                              Navigator.pushNamed(context, '/SaveFaces');
                            }
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE FACES",
                            style: new TextStyle(
                                fontSize: 34.0,
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
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("SAVE PRE DEFINED MESSAGE");
                            _startTimer();
                            if (goOrNot(2)) {
                              Navigator.pushNamed(context, '/SaveSos');
                            }
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "SAVE PRE-DEFINED MESSAGE",
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
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 18 - 12.58,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("RESET");
                            _startTimer();
                            if (goOrNot(2)) {}
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "RESET ",
                            style: new TextStyle(
                                fontSize: 34.0,
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
                        height: SizeConfig.safeBlockVertical * 2,
                        width: SizeConfig.safeBlockHorizontal * 100,
                      ),
                    ])))));
  }
}
