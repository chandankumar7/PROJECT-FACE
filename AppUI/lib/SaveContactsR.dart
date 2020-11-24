import 'dart:math';
import 'package:contact_picker/contact_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_trial/TextToSpeech.dart';
import 'dart:async';
import 'Size_Config.dart';
import 'homeR.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'dart:convert';


class SaveContacts extends StatefulWidget {
  io.File jsonFileFace ;
  io.File jsonFileSos ;
  SaveContacts({this.jsonFileFace,this.jsonFileSos});

  @override
  _SaveContactsState createState() => _SaveContactsState(this.jsonFileFace,this.jsonFileSos);
}

class _SaveContactsState extends State<SaveContacts> {

   io.File jsonFileFace ;
   io.File jsonFileSos ;
  _SaveContactsState(this.jsonFileFace,this.jsonFileSos);
  dynamic data={};
  Map<String, dynamic> fileContent; 
  Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;



  TextToSpeech tts = new TextToSpeech();
  final timeout = const Duration(seconds: 3);
  final ContactPicker _contactPicker = new ContactPicker();

 var go = [
    false,
    false,
  ]; //0: save contacts, 1: clear file


  bool goOrNot(int touch) {
    if (go[touch]) {
      go[touch] = false;
      return true;
    } else {
      for (int i = 0; i < 2; i++) {
        if (i == touch)
          go[touch] = true;
        else
          go[i] = false;
      }
        return false;
    }
  
  }

  void cancelTouch() {
    for (int i = 0; i < 2; i++) go[i] = false;
  }

  void _startTimer() {
    Timer _timer;
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      cancelTouch();
      timer.cancel();
    });
  }

  void _resetFile() {
    Map<String,dynamic> count={"count":"0"};
    jsonFileSos.writeAsStringSync(json.encode(count));
    tts.tell("Contacts Cleared");
    Future.delayed(Duration(seconds: 1),(){setState(() {
      
    });}) ;
  }

  Widget showContacts(){
    try{

    print("inside try");      
    Map<String,dynamic> data1 = json.decode(jsonFileSos.readAsStringSync());
    var count=data1['count'];
    if(int.parse(count)==0)
      return Container();
    else {
      List names=[];
      List numbers=[];
      data1.forEach((key, value) {
      if(key.contains("name"))
        names.add(value);
      else
       if(key.contains("number"))
          numbers.add(value);  
    });
    print(names);
    print(numbers);
      return ListView.builder(
         itemCount:int.parse(count),
         itemBuilder: (BuildContext context, int index) {
          return new Column(
          children: <Widget>[
            Container(
                        height: SizeConfig.safeBlockVertical * 15,
                        width: SizeConfig.safeBlockHorizontal * 100,
              child: 
              RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("SAVE CONTACTS");
                          },
                          color: const Color(0xFF266EC0),
                          child: Center(
child:   Column(children: <Widget>[
    new Text(
                            names[index],
                            style: new TextStyle(
                                fontSize: 25.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          new Text(
                            numbers[index],
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          ],
                          
                          ),
                          ),
                       
 
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
            ),
        new Divider(
          height: 2.0,
        ),
      ],
    );
  }
  );
    }
    }
    catch(e){
      print(e.toString());
      return Container();
    }
 
    
  }


    void pickcontacts() async {
    requestPermission(Permission.contacts);
    Contact contact;
    try {
          contact = await _contactPicker.selectContact();
    } catch (e) {
      print(e.toString());
    }
    print("Contact Picked");
    String name=contact.fullName;
    String number=contact.phoneNumber.number.toString();
    String n;
    if(number.contains("+91"))
      {
        print("inside +91");
        n=number.replaceAll("+91", "").trim();
  
      }
    else{
      n=number.trim();
    }  
    fillJson(name, n);
  }


   void fillJson(String name,String number){
     print("Inside Json");
     Map<String,dynamic> data = json.decode(jsonFileSos.readAsStringSync());
     var d_count=data['count'];
     int count=int.parse(d_count);
     print("count="+count.toString());
     if(count<4){
     count++;
     Map<String,dynamic> map={"name_"+count.toString():name,"number_"+count.toString():number};
     Map<String,dynamic> cMap={"count":count.toString()};
     data.addAll(cMap);
     data.addAll(map);

    print(data);
     try{
       jsonFileSos.writeAsStringSync(json.encode(data));
      print("success");
    }catch(e){print(e.toString());}

    Map<String,dynamic> data1 = json.decode(jsonFileSos.readAsStringSync());
    print("data1:"+data1.toString());
    setState(() {
      
    });
   }
   else{
     print("max reached");
   }
  }

Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tts.tellCurrentScreen("Save Contacts");
    return MaterialApp(
        routes: { '/home': (context) => Home(jsonFileFace : jsonFileFace,jsonFileSos: jsonFileSos )},
        title: 'SaveContacts_trial',
        home: Builder(builder: (context) => new Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Color(0xFF00B1D2),
            appBar: new AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
               onPressed: () => Navigator.pushNamed(context, '/home'),
              ),
              title: new Text('Save Contacts'),
              backgroundColor: Color(0xFF1C3BC8),
            ),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta < -20) {
                    tts.tellDateTime();
                  }
                  if (details.primaryDelta > 20)
                    tts.tellCurrentScreen("Save Contacts");
                },
                child: Column(children: <Widget>[     Container(
                   height: SizeConfig.safeBlockVertical * 50,
                   width: SizeConfig.safeBlockHorizontal * 100,
                   child:showContacts(),
                ),
                SizedBox(height:SizeConfig.safeBlockVertical * 20, ),
               RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("Save Contact");
                            _startTimer();
                            if (goOrNot(0)) {
                              print("inside");
                              pickcontacts();
                            }
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "Save Contact",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 30.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                          RaisedButton(
                          key: null,
                          onPressed: () {
                            tts.tellPress("Clear File");
                            _startTimer();
                            if (goOrNot(1)) {
                              print("inside clear");
                              _resetFile();
                           
                            }
                          },
                          color: const Color(0xFF266EC0),
                          child: new Text(
                            "Clear File",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 30.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                              ]
                              )
           
                ))
    ));
  }
}

