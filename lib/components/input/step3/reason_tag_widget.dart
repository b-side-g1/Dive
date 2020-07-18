import 'package:flutter/material.dart';


class ReasonTagWidget extends StatefulWidget {
  @override
  _BuildReasonTagState createState() => _BuildReasonTagState();
}

class _BuildReasonTagState extends State<ReasonTagWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(
          color: Colors.black
        ),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Text("hello"),
    );
  }
}
