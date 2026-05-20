import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  final double padding = 1.0;
  final String title;

  Tag({super.key, required this.title});

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    void setColor() {
      setState(() {
        isSelected = !isSelected;
      });
    }

    return GestureDetector(
      onTap: setColor,
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(0, 0, 0, 0.5)
                : const Color.fromRGBO(0, 0, 0, 0.0)),
        padding: EdgeInsets.all(widget.padding),
        child: Text(widget.title),
      ),
    );
  }
}
