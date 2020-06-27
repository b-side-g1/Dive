import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/RecordingForm.dart';

class InputPage extends StatefulWidget {
  InputPage() : super();

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RecordingForm(),
      );
  }

}