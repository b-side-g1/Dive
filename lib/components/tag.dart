import 'package:flutter/cupertino.dart';

class Tag extends StatefulWidget {
  final padding = 1.0;
  String title;

  Tag({Key key, this.title}) : super(key: key);

  @override
  _TagState createState() {
    return _TagState();
  }
}

class _TagState extends State<Tag> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    _setColor() {
      setState(() {
        isSelected = !isSelected;
      });
    }

    return GestureDetector(
      onTap: _setColor,
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? Color.fromRGBO(0, 0, 0, 0.5)
                : Color.fromRGBO(0, 0, 0, 0.0)),
        padding: EdgeInsets.all(widget.padding),
        child: Text(widget.title),
      ),
    );
  }
}
