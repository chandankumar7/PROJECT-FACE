import 'package:flutter/material.dart';
import 'Size_Config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scale UI to fit multiple display sizes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(children:<Widget>[
         Container(
        height: SizeConfig.safeBlockVertical*49.5-28,
        width: SizeConfig.safeBlockHorizontal*100,
        color:Colors.white,
        child: Row(
          children:<Widget>[
            Container(
              height: SizeConfig.safeBlockVertical*49.5-28,
              width: SizeConfig.safeBlockHorizontal*49,
              color:Colors.purple,

            ),
            SizedBox(
              height:SizeConfig.safeBlockVertical*49.5-28,
              width:SizeConfig.safeBlockHorizontal*2,
            ),
            Container(
              height: SizeConfig.safeBlockVertical*49.5-28,
              width: SizeConfig.safeBlockHorizontal*49,
              color:Colors.purple,

            )
          ]
        ),
         ),
         SizedBox(
           height:SizeConfig.safeBlockVertical*1,
           width:SizeConfig.safeBlockHorizontal*100
         ),
          Container(
        height: SizeConfig.safeBlockVertical*49.5-28,
        width: SizeConfig.safeBlockHorizontal*100,
        color:Colors.white,
        child: Row(
          children:<Widget>[
            Container(
              height: SizeConfig.safeBlockVertical*49.5-28,
              width: SizeConfig.safeBlockHorizontal*49,
              color:Colors.purple,

            ),
            SizedBox(
              height:SizeConfig.safeBlockVertical*49.5-28,
              width:SizeConfig.safeBlockHorizontal*2,
            ),
            Container(
              height: SizeConfig.safeBlockVertical*49.5-28,
              width: SizeConfig.safeBlockHorizontal*49,
              color:Colors.purple,

            )
          ]
        ),
         )
      ]
      )
      );
  }
}
    
      
