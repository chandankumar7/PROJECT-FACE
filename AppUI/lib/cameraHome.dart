import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:ui_trial/SaveFacesR.dart';
import 'Size_Config.dart';
import 'homeR.dart';
import 'util.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

class cameraHome extends StatefulWidget {
  io.File jsonFile;
  cameraHome({this.jsonFile});

  @override
  _cameraHomeState createState() => _cameraHomeState(this.jsonFile);
}

class _cameraHomeState extends State<cameraHome> {
  io.File jsonFile;
  _cameraHomeState(this.jsonFile);
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
    jsonFile.deleteSync();
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
      final gpuDelegateV2 = tfl.GpuDelegateV2(
          options: tfl.GpuDelegateOptionsV2(
        false,
        tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
        tfl.TfLiteGpuInferencePriority.minLatency,
        tfl.TfLiteGpuInferencePriority.auto,
        tfl.TfLiteGpuInferencePriority.auto,
      ));

      var interpreterOptions = tfl.InterpreterOptions()
        ..addDelegate(gpuDelegateV2);
      interpreter = await tfl.Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print("error while loading model" + e.toString());
    }

    if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());

    _camera.startImageStream((image) {
      if (_camera != null) {
        if (_isDetecting) return;
        _isDetecting = true;
        detect(image, _getFaceDetectionMethod(), rotation)
            .then((dynamic result) async {
          setState(() {});
          if (result.length == 0) {
            print("face Not found");
          } else {
            Face _face;
            print("Face Found");
            imglib.Image convertedImage =
                _convertCameraImage(image, _direction);
            for (_face in result) {
              print(_face.boundingBox.left.toString());
              double x, y, w, h;
              x = (_face.boundingBox.left - 10);
              y = (_face.boundingBox.top - 10);
              w = (_face.boundingBox.width + 10);
              h = (_face.boundingBox.height + 10);
              imglib.Image croppedImage = imglib.copyCrop(
                  convertedImage, x.round(), y.round(), w.round(), h.round());
              print("1:  " +
                  croppedImage.width.toString() +
                  " " +
                  croppedImage.height.toString());
              croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
              print("2:  " +
                  croppedImage.width.toString() +
                  " " +
                  croppedImage.height.toString());
              var op = preProcess(croppedImage);
              res = _recog(op);
            }
          }
          _isDetecting = false;
        });
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
          '/saveFaces': (context) => SaveFaces(jsonFile: jsonFile),
          '/home': (context) => Home(jsonFile: jsonFile)
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
                            Navigator.pushNamed(context, '/saveFaces');
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
                            _resetFile();
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

HandleDetection _getFaceDetectionMethod() {
  final faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    mode: FaceDetectorMode.accurate,
  ));
  return faceDetector.processImage;
}

imglib.Image _convertCameraImage(CameraImage image, CameraLensDirection _dir) {
  int width = image.width;
  int height = image.height;
  var img = imglib.Image(width, height);
  const int hexFF = 0xFF000000;
  final int uvyButtonStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = image.planes[1].bytesPerPixel;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
      final int index = y * width + x;
      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      img.data[index] = hexFF | (b << 16) | (g << 8) | r;
    }
  }
  var img1 = (_dir == CameraLensDirection.front)
      ? imglib.copyRotate(img, -90)
      : imglib.copyRotate(img, 90);
  return img1;
}
