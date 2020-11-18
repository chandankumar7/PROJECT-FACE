import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:android_intent/android_intent.dart';
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/initialisationR.dart';
import 'muteR.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';


class Home extends StatefulWidget {
  io.File jsonFile;
  Home({this.jsonFile});
  @override
  _HomeState createState() => _HomeState(this.jsonFile);
}

class _HomeState extends State<Home> {
  io.File jsonFile;
  _HomeState(this.jsonFile);

  var internet=false;

  final TextToSpeech tts = new TextToSpeech();
  final SpeechToText speech = SpeechToText();

  final timeout = const Duration(seconds: 3);

  var go = [
    false,
    false,
    false,
    false
  ]; //0:sos,1:mute,2:initialisation,3:navigation

  void initVoiceInput()async{
    try{
        bool hasSpeech = await speech.initialize();
        if(hasSpeech)
          print("initialised");
    }catch(e){print("Error while Initialising speech to text:"+e.toString());}
  }

 checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) 
        internet=true;
  }

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

  void loadJson() async {
    io.Directory tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new io.File(_embPath);
  }

   void _launchTurnByTurnNavigationInGoogleMaps(String location) {
    final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('google.navigation:q='+location),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    try {
      jsonFile.exists();
    } catch (e) {
      loadJson();
      print("Created File");
    }
    checkInternet();
    SizeConfig().init(context);
    tts.tellCurrentScreen("Home");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        routes: {
          '/mute': (context) => Mute(),
          '/initialisation': (context) => Initialisation(jsonFile: jsonFile)
        },
        title: "home_trial",
        home: Builder(
            builder: (context) => Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  title: Text("360 VPA"),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta < -20) {
                      tts.tellDateTime();
                    }
                    if (details.primaryDelta > 20)
                      tts.tellCurrentScreen("Home");
                  },
                  child: Column(children: <Widget>[
                    Container(
                      height: SizeConfig.safeBlockVertical * 49.5 - 28,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      color: Colors.white,
                      child: Row(children: <Widget>[
                        Container(
                            height: SizeConfig.safeBlockVertical * 49.5 - 28,
                            width: SizeConfig.safeBlockHorizontal * 49,
                            color: Colors.purple,
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
                                ))),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 49.5 - 28,
                          width: SizeConfig.safeBlockHorizontal * 2,
                        ),
                        Container(
                            height: SizeConfig.safeBlockVertical * 49.5 - 28,
                            width: SizeConfig.safeBlockHorizontal * 49,
                            color: Colors.purple,
                            child: RaisedButton(
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
                                )))
                      ]),
                    ),
                    SizedBox(
                        height: SizeConfig.safeBlockVertical * 1,
                        width: SizeConfig.safeBlockHorizontal * 100),
                    Container(
                      height: SizeConfig.safeBlockVertical * 49.5 - 28,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      color: Colors.white,
                      child: Row(children: <Widget>[
                        Container(
                          height: SizeConfig.safeBlockVertical * 49.5 - 28,
                          width: SizeConfig.safeBlockHorizontal * 49,
                          color: Colors.purple,
                          child: RaisedButton(
                              key: null,
                              onPressed: () {
                                tts.tellPress("Navigation");
                                _startTimer();
                                if (goOrNot(3)) {
                                  checkInternet();
                                  if(!internet)
                                    {
                                      print("No Internet");
                                      tts.tell("You dont have an active internet connection");
                                    }
                                  else{
                                    tts.tell("Set your destination after the beep");
                                    Future.delayed(Duration(seconds: 4),()async{
                                            await initVoiceInput();
                                            speech.listen(
                                            onResult: (SpeechRecognitionResult result)async {
                                                      
                                                      tts.tell("You entered Your Destination as "+result.recognizedWords+"Say yes to confirm the destination after the beep");
                                                      speech.cancel();
                                                      speech.initialize();
                                                      Future.delayed(Duration(seconds: 7),(){
                                                          speech.listen(
                                                        onResult:(SpeechRecognitionResult result1){
                                                          if(result1.recognizedWords.compareTo("yes")==0)
                                                             _launchTurnByTurnNavigationInGoogleMaps(result.recognizedWords);
                                                          else
                                                             print("cannot confirm");   
                                                        },
                                                      listenFor: Duration(seconds: 10),
                                                      pauseFor: Duration(seconds:5),
                                                      partialResults: false,
                                                      listenMode: ListenMode.confirmation);
                                                      });
                                                    

                                                    },
                                            listenFor: Duration(seconds: 10),

                                            pauseFor: Duration(seconds:5),
                                            partialResults: false,
                                            listenMode: ListenMode.dictation);
                                      });
                                  }  
                                }
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
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 49.5 - 28,
                          width: SizeConfig.safeBlockHorizontal * 2,
                        ),
                        Container(
                            height: SizeConfig.safeBlockVertical * 49.5 - 28,
                            width: SizeConfig.safeBlockHorizontal * 49,
                            color: Colors.purple,
                            child: RaisedButton(
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
                                )))
                      ]),
                    )
                  ]),
                ))));
  }
}
