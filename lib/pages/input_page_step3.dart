import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep3 extends StatefulWidget {
  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 110, left: 70, right: 70),
                  child: Center(
                      child: Text("그렇게 느끼는 이유는...",style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700
                      ),))),
              Container(
                  padding: EdgeInsets.only(top: 30,left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("이유태그",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
//                      Row(
//                        children: <Widget>[
//                          Icon(
//                              Icons.forward
//                          ),
//                          Text("태그편집"),
//                        ],
//                      )
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(
                                Icons.edit
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("태그편집",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ],
          )),
    );
  }
}
