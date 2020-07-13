import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep3 extends StatefulWidget {
  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
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
              color: Colors.yellowAccent, //
            )),
      ),
    );
  }
}
