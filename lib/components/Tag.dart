import 'package:flutter/cupertino.dart';

class Tag extends StatefulWidget {
  final padding = 1.0;
  bool isSelected = false;
  String title;

  Tag({Key key, this.title, this.isSelected}) : super(key: key);

//  new


  @override
  _TagState createState() {
    return _TagState();
  }
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(widget.padding), child: Text(widget.title));
  }
}