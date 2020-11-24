import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' as io;
import 'util.dart';
import 'Size_Config.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'homeR.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:ui_trial/TextToSpeech.dart';




class objectDetection extends StatefulWidget {
  io.File jsonFileFace ;
  io.File jsonFileSos ;
  objectDetection({this.jsonFileFace,this.jsonFileSos });
  @override
  _objectDetectionState createState() => _objectDetectionState(this.jsonFileFace,this.jsonFileSos);
}

class _objectDetectionState extends State<objectDetection> {
  io.File jsonFileFace ;
  io.File jsonFileSos ;
  _objectDetectionState(this.jsonFileFace,this.jsonFileSos);
  FlutterTts tts = new FlutterTts();

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;
  CameraController _camera;
  var interpreter;
  List e1;
  dynamic data = {};
  double threshold = 1.0;
  String res;
  io.Directory tempDir;

  void _resetFile() {
    data = {};
    jsonFileFace  .deleteSync();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  List<dynamic> preProcess(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List(1 * 192).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    return output;
  }

  String _recog(List<dynamic> output) {
    e1 = List.from(output);
    return compare(e1).toUpperCase();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String label1;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      label1 = label;
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }
    if (predRes.compareTo("NOT RECOGNIZED") == 0) {
    } else {
      tts.speak(predRes);
    }
    print(currDist.toString() +
        " " +
        label1 +
        "   " +
        predRes +
        " " +
        data.length.toString());
    return predRes;
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);

    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
    _camera =
        CameraController(description, ResolutionPreset.low, enableAudio: false);
    await _camera.initialize();
    await Future.delayed(Duration(milliseconds: 500));
    try {
          String res = await Tflite.loadModel(
          model: "assets/mobilenet_v1_1.0_224.tflite",
          labels: "assets/mobilenet_v1_1.0_224.txt",
          numThreads: 1, // defaults to 1
          isAsset: true, // defaults to true, set to false to load resources outside assets
          useGpuDelegate: false // defaults to false, set to true to use GPU delegate
        );
    } catch (e) {
      print("error while loading model" + e.toString());
    }

    _camera.startImageStream((image) async{
      if (_camera != null) {
        if (_isDetecting) return;
        _isDetecting = true;
        var recognitions = await Tflite.detectObjectOnFrame(
            bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),
          //  imageHeight: image.height,
          //  imageWidth: image.width,
);
print(recognitions.first.toString());
_isDetecting=false;
       
      }
    });
  }

  Widget _showCamera() {
    if (_camera == null)
      return Center(
          child: Container(
              height: 200, width: 200, child: CircularProgressIndicator()));
    else
      return CameraPreview(_camera);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        routes: {
          '/home': (context) => Home(jsonFileFace : jsonFileFace,jsonFileSos: jsonFileSos )
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
                  title: new Text('Camera '),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: Column(
                  children: <Widget>[
                    Container(height: 450, width: 360, child: _showCamera()),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                      width: SizeConfig.safeBlockHorizontal * 100,
                    ),
                    Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          onPressed: () {
                            _camera.dispose();
                      //      Navigator.pushNamed(context, '/saveFaces');
                          },
                          color: const Color(0xFF266EC0),
                          child: Text("SAVE FACE",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 35.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto")),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        )),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                      width: SizeConfig.safeBlockHorizontal * 100,
                    ),
                    Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: RaisedButton(
                          onPressed: () {
                       //     _resetFile();
                          },
                          color: const Color(0xFF266EC0),
                          child: Text("RESET FILE",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 35.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto")),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        )),
                  ],
                ))));
  }
}



