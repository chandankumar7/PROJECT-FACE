import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'Size_Config.dart';
import 'TextToSpeech.dart';
import 'package:camera/camera.dart';
import 'util.dart';
import 'package:flutter/services.dart';
import 'homeR.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:async';

class read extends StatefulWidget {
  io.File jsonFileFace;
  io.File jsonFileSos;
  read({this.jsonFileFace, this.jsonFileSos});
  @override
  _readState createState() => _readState(this.jsonFileFace, this.jsonFileSos);
}

class _readState extends State<read> {
  io.File jsonFileFace;
  io.File jsonFileSos;
  _readState(this.jsonFileFace, this.jsonFileSos);
  TextToSpeech tts = new TextToSpeech();
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;
  CameraController _camera;
  List<String> words = [];
  bool _isSpeaking = false;

  var go = [
    false,
  ]; //0:read

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

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    final TextRecognizer _textRecognizer =
        FirebaseVision.instance.textRecognizer();

    _camera =
        CameraController(description, ResolutionPreset.low, enableAudio: false);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
    await _camera.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {});
    Future.delayed(Duration(seconds: 2));
    _camera.startImageStream((image) {
      if (!_isDetecting) {
        _isDetecting = true;
        FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
            image.planes[0].bytes, buildMetaData(image, rotation));
        _textRecognizer.processImage(visionImage).then((VisionText result) {
          for (TextBlock block in result.blocks) {
            for (TextLine line in block.lines) {
              for (TextElement word in line.elements) {
                if (words.length < 30) {
                  words.insert(words.length, word.text);
                  print(words);
                } else {
                  words = [];
                }
              }
            }
          }
        });
      }
      _isDetecting = false;
    });
  }

  Widget _showCamera() {
    if (_camera == null || _isSpeaking)
      return Center(
          child: Container(
              height: 200, width: 200, child: CircularProgressIndicator()));
    else
      return CameraPreview(_camera);
  }

  void read() {
    if (!_isSpeaking) {
      bool _isInside = false;
      if (words.isEmpty) {
        tts.tell("No Text found");
      } else {
        words.forEach((element) async {
          if (!_isInside) {
            _isInside = true;
            tts.tell(element);
            _isInside = false;
          }
        });
        words = [];
        _isSpeaking = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        routes: {
          '/home': (context) =>
              Home(jsonFileFace: jsonFileFace, jsonFileSos: jsonFileSos)
        },
        home: Builder(
            builder: (context) => Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () {
                        _camera.dispose();
                        Navigator.pushNamed(context, '/home');
                      }),
                  title: new Text('Read Text'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: Column(
                  children: <Widget>[
                    Container(
                      height: SizeConfig.safeBlockVertical * 70,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      child: _showCamera(),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      key: null,
                      onPressed: () {
                        tts.tellPress("Read Words");
                        if (goOrNot(0)) {
                          setState(() {});
                          read();
                        }
                      },
                      color: const Color(0xFF266EC0),
                      child: new Text(
                        "Read",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 35.0,
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                    )
                  ],
                ))));
  }
}
