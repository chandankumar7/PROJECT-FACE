import 'package:flutter/material.dart';
import 'package:ui_trial/SaveFacesR.dart';
import 'package:ui_trial/cameraHome.dart';
import 'SignUpUser.dart';
import 'Size_Config.dart';
import 'homeR.dart';
import 'initialisationR.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    
  io.File jsonFile;
  

  void loadJson()async{
    io.Directory tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new io.File(_embPath);

  }

  @override
  Widget build(BuildContext context) {
    loadJson();
    return MaterialApp(
      routes: {
        '/cameraHome':(context)=> cameraHome(jsonFile: jsonFile)
      },
      title: '360 VPA APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder( builder:
         (context){
              Navigator.pushNamed(context, '/cameraHome');
        } 
      )
    );
  }
}
