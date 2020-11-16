import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'package:ui_trial/cameraHome.dart';
import 'dart:async';
import 'homeR.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io' as io;
import 'util.dart';
import 'dart:convert';


class SaveFaces extends StatefulWidget {
  
  io.File jsonFile;
  SaveFaces({@required this.jsonFile});

  @override
  _SaveFacesState createState() => _SaveFacesState(this.jsonFile);
}

class _SaveFacesState extends State<SaveFaces> {
  io.File jsonFile;
  _SaveFacesState(this.jsonFile);
  TextToSpeech tts = new TextToSpeech();
  TextEditingController _textController=TextEditingController();
  var interpreter;
  Image imgToShow,img;
  imglib.Image convertedImage;
  dynamic data={};
  dynamic data1={};
  io.Directory tempDir;
  bool isLoaded=false;
  int current_showing=-1;

  
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
    void pick_image()async{
     try{
        final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
        final _imagepicker=ImagePicker();
        var temp_img=await _imagepicker.getImage(source: ImageSource.gallery);
        var file=io.File(temp_img.path).readAsBytesSync();
        img=Image.memory(file); //to display on widget
        convertedImage=imglib.decodeImage(file);//converted picked Image to Image class
        FirebaseVisionImage image=FirebaseVisionImage.fromFilePath(temp_img.path);  //Created firebase image
        List<Face>result=await faceDetector.processImage(image);
        Face _face;
        if(result.isEmpty)
          {
            print("No Face");
          }
        else
        { 

              for(_face in result)
              {
                double x, y, w, h;
                x = (_face.boundingBox.left - 10);
                y = (_face.boundingBox.top - 10);
                w = (_face.boundingBox.width + 10);
                h = (_face.boundingBox.height + 10);
                print("y:"+_face.headEulerAngleY.toString()+" z:"+_face.headEulerAngleZ.toString());
                imglib.Image croppedImage = imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
                print("1:  "+croppedImage.width.toString()+" "+croppedImage.height.toString());
                croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
                print("2:  "+croppedImage.width.toString()+" "+croppedImage.height.toString());
                var op=preProcess(croppedImage);
                if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());          
                data[_textController.text] = List.from(op);
                jsonFile.writeAsStringSync(json.encode(data));
                if (jsonFile.existsSync()) data1 = json.decode(jsonFile.readAsStringSync());
              }
        }  

        setState(() {
          isLoaded=true;
          imgToShow=img;
        });
     
    }catch(e){print("error while picking Image"+e.toString());}
  

  }

 void saveFacesMethod()async{
       try{ 
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

    }catch(e){print("error while loading model"+e.toString());}
    pick_image();
  

  }

  List<dynamic> preProcess(imglib.Image img){
  List input = imageToByteListFloat32(img, 112, 128, 128);
  input = input.reshape([1, 112, 112, 3]);
  List output = List(1 * 192).reshape([1, 192]);
  interpreter.run(input, output);
  output = output.reshape([192]);
  return output;
}
 

 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tts.tellCurrentScreen("Save Faces");
    return MaterialApp(
        routes: {'/home': (context) => Home(jsonFile:jsonFile),
        '/camera':(context)=> cameraHome(jsonFile:jsonFile)},
        title: 'SaveFaces_trial',
        home: Builder(
            builder: (context) => Scaffold(
                backgroundColor: Color(0xFF00B1D2),
                appBar: new AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                  title: new Text('Save Faces '),
                  backgroundColor: Color(0xFF1C3BC8),
                ),
                body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: (details) {
                      tts.tellCurrentScreen("Save Faces");
                    },
                    child: Column(
                      children: <Widget>[
                         Container(
                           height:300,
                           child: isLoaded? imgToShow: Icon(Icons.face_rounded),
                         ),
                         new TextField(
                          controller: _textController, 
                          style: new TextStyle(
                              fontSize: 25.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto"),
                              keyboardType: TextInputType.name,
                              onTap: (){
                                if(_textController.text.isEmpty)
                                tts.promptInput("Enter Name");
                              },
                              onChanged: (value) {
                                tts.inputPlayback(value);
                              },
                           ),
                          RaisedButton(
                            key: null,
                            onPressed: () {
                              tts.tellPress("Choose a face");
                              _startTimer();
                              if (goOrNot(0)) {
                                   if(_textController.text.isEmpty){
                                     tts.promptInput("Name cant Be empty");
                                     return;
                                   }
                              
                             else{
                               saveFacesMethod();
                             }
                            }
                           },
                             
  
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "Choose Face",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 29.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            )),
                                RaisedButton(
                            key: null,
                            onPressed: () {
                                 Navigator.pushNamed(context, '/camera');

                           },
                             
  
                            color: const Color(0xFF266EC0),
                            child: new Text(
                              "Go To Camera",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 29.0,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            )),
                        
                      ]
                    ) 
                       
                    )
                    )
                    )
                    );
  }
}

