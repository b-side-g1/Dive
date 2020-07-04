import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep1 extends StatefulWidget {
  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
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
        ),
      ),
    );
  }
}
