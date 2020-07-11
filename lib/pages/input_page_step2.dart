import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep2 extends StatefulWidget {
  @override
  _InputPageStep2State createState() => _InputPageStep2State();
}

class _InputPageStep2State extends State<InputPageStep2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/src/image/marble.png')),
      ),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/src/image/marble_shadow.png'),
                alignment: Alignment(0.0, 0.75)),
            border: Border.all(
              width: 1,
              color: Colors.pink, //
            )),
      ),
    );
  }
}
