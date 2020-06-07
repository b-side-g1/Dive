import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  InputComponent({Key key, this.title, this.validator, this.keyboardType, this.controller})
      : super(key: key);

  String title;
  Function validator;
  TextInputType keyboardType = TextInputType.text;
  TextEditingController controller;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(this.title),
        TextFormField(
          key: Key(title),
          keyboardType: this.keyboardType,
          validator: this.validator,
          autovalidate: true,
          controller: this.controller,
        ),
      ],
    );
  }
}
