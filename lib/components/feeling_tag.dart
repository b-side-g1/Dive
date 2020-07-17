import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class FeelingTag extends StatefulWidget {
//  final padding = 1.0;
  String title;
  int feelingTagId;
  double width = 34;
  double height = 34;
  Function onClick;
  bool isActivated = false;
  Color activeColor;

  FeelingTag({Key key, this.feelingTagId, this.title, this.onClick, this.activeColor})
      : super(key: key);

  @override
  _FeelingTagState createState() {
    return _FeelingTagState();
  }
}

class _FeelingTagState extends State<FeelingTag> {
  @override
  Widget build(BuildContext context) {
    __onClick() {
      if(widget.onClick != null) widget.onClick();
      setState(() => {widget.isActivated = !widget.isActivated});
    }

    return GestureDetector(
        onTap: __onClick,
        child: Container(
          height: widget.width,
          width: widget.height,
          decoration: BoxDecoration(
            color: widget.isActivated
                ? widget.activeColor
                : Color.fromRGBO(255, 255, 255, 0.03),
//          image: DecorationImage(
//            image: AssetImage('lib/src/image/tags/icon_1_off.png'),
//            fit: BoxFit.scaleDown,
//          )
            borderRadius:
                BorderRadius.all(Radius.circular(9.9)),
          ),
          child: Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'lib/src/image/tags/icon_${widget.feelingTagId}_${widget.isActivated ? 'on' : 'off'}.png',
                    // image height, width: 16.7dp
                    height:
                        16.7 / widget.height * (100 + 9),
                    width:
                        16.7 / widget.width * (100 + 9),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              )),
        ));
  }
}
