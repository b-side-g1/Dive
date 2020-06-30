import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  InputPage() : super();

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    int step = 1;
    _setBackGround() {
      switch (step) {
        case 1:
          return Color.fromRGBO(43, 99, 194, 1.0);
        case 2:
          return Color.fromRGBO(20, 69, 151, 1.0);
        case 3:
          return Color.fromRGBO(12, 48, 107, 1.0);
      }
    }

    return Container(
      decoration: BoxDecoration(color: _setBackGround()),
      child: null,
    );
  }
}
