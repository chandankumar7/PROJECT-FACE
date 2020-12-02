import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'Size_Config.dart';
import 'homeR.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart' as tfl;
import 'util.dart';

bool debugShowCheckedModeBanner = true;

class objectDetection extends StatefulWidget {
  io.File jsonFileFace;
  io.File jsonFileSos;
  objectDetection({this.jsonFileFace, this.jsonFileSos});
  @override
  _objectDetectionState createState() =>
      _objectDetectionState(this.jsonFileFace, this.jsonFileSos);
}

class _objectDetectionState extends State<objectDetection> {
  io.File jsonFileFace;
  io.File jsonFileSos;
  _objectDetectionState(this.jsonFileFace, this.jsonFileSos);
  FlutterTts tts = new FlutterTts();
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;
  CameraController _camera;
  List<String> objects = [];

  void giveOutput(String s) {
    if (objects.contains(s))
      ;
    else {
      objects.insert(objects.length, s);
      print("inserted at " + objects.length.toString());
      tts.speak(s);
      Future.delayed(Duration(seconds: 5), () {
        objects = [];
      });
    }
  }

  loadTfModel() async {
    await tfl.Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/labels.txt",
    );
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);

    _camera =
        CameraController(description, ResolutionPreset.low, enableAudio: false);
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
        tfl.Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "SSDMobileNet",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          numResultsPerClass: 3,
          threshold: 0.7,
        ).then((recognitions) {
          recognitions.forEach((element) {
            giveOutput(element['detectedClass']);
          });
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
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
    loadTfModel();
  }

  @override
  void dispose() {
    try {
      _camera?.dispose();
    } catch (err) {
      print(err);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                  title: new Text('Object Detection'),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: Container(
                  height: SizeConfig.safeBlockVertical * 70,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  child: _showCamera(),
                ))));
  }
}
