import 'package:flutter/material.dart';
import 'Size_Config.dart';

class screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      Scaffold(
        appBar: AppBar(),
        backgroundColor: const Color(0xFF00B1D2),
        body:
        Column(
          children:
          <Widget>[
            SizedBox(
               height: SizeConfig.safeBlockVertical*2,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
                  Container(
              height: SizeConfig.safeBlockVertical*18-12.58,
               width: SizeConfig.safeBlockHorizontal*100,
               child: RaisedButton(
                onPressed: (){},
                color:const Color(0xFF266EC0)
              ),
            ),
            SizedBox(
               height: SizeConfig.safeBlockVertical*2,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
                  Container(
              height: SizeConfig.safeBlockVertical*18-12.58,
               width: SizeConfig.safeBlockHorizontal*100,
               child: RaisedButton(
                onPressed: (){},
                color:const Color(0xFF266EC0)
              ),
            ),
            SizedBox(
               height: SizeConfig.safeBlockVertical*2,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
                  Container(
              height: SizeConfig.safeBlockVertical*18-12.58,
               width: SizeConfig.safeBlockHorizontal*100,
               child: RaisedButton(
                onPressed: (){},
                color:const Color(0xFF266EC0)
              ),
            ),
            SizedBox(
               height: SizeConfig.safeBlockVertical*2,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
                  Container(
              height: SizeConfig.safeBlockVertical*18-12.58,
               width: SizeConfig.safeBlockHorizontal*100,
               child: RaisedButton(
                onPressed: (){},
                color:const Color(0xFF266EC0)
              ),
            ),
            SizedBox(
               height: SizeConfig.safeBlockVertical*2,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
                  Container(
              height: SizeConfig.safeBlockVertical*18-12.58,
               width: SizeConfig.safeBlockHorizontal*100,
               child: RaisedButton(
                onPressed: (){},
                color:const Color(0xFF266EC0)
              ),
            ),
             SizedBox(
               height: SizeConfig.safeBlockVertical*1,
               width: SizeConfig.safeBlockHorizontal*100,
            ),
          
          ]
        )
        )
    );
  }
}