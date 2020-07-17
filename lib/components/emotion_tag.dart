import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class EmotionTag extends StatefulWidget {
//  final padding = 1.0;
  String title;
  int emotionTagId;
  double width = 34;
  double height = 34;
  Function onClick;
  Color activeColor;

  EmotionTag(
      {Key key, this.emotionTagId, this.title, this.onClick, this.activeColor})
      : super(key: key);

  @override
  _EmotionTagState createState() {
    return _EmotionTagState();
  }
}

class _EmotionTagState extends State<EmotionTag> {
  bool _isActivated = false;

  get isActivated => this._isActivated;

  set isActivated(value) => {this._isActivated = value};

  @override
  Widget build(BuildContext context) {
    __onClick() {
      setState(() => {isActivated = !isActivated});
      print(31);
      print(isActivated);
      if (widget.onClick != null) widget.onClick(isActivated);
    }

    return GestureDetector(
        onTap: __onClick,
        child: Container(
          height: widget.width,
          width: widget.height,
          decoration: BoxDecoration(
            color: _isActivated
                ? widget.activeColor
                : Color.fromRGBO(255, 255, 255, 0.03),
//          image: DecorationImage(
//            image: AssetImage('lib/src/image/tags/icon_1_off.png'),
//            fit: BoxFit.scaleDown,
//          )
            borderRadius: BorderRadius.all(Radius.circular(9.9)),
          ),
          child: Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'lib/src/image/tags/icon_${widget.emotionTagId}_${_isActivated ? 'on' : 'off'}.png',
                    // image height, width: 16.7dp
                    height: 16.7 / widget.height * (100 + 9),
                    width: 16.7 / widget.width * (100 + 9),
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
