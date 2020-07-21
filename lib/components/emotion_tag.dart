import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class EmotionTag extends StatefulWidget {
  String title;
  int id;
  double width = 34;
  double height = 34;
  Function onTap;
  List<Color> activeColors;
  bool isActivated;

  EmotionTag(
      {Key key,
      this.id,
      this.title,
      this.onTap,
      this.activeColors,
      this.isActivated})
      : super(key: key);

  @override
  _EmotionTagState createState() {
    return _EmotionTagState();
  }
}

class _EmotionTagState extends State<EmotionTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.width,
          width: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isActivated
                  ? widget.activeColors
                  : [Color.fromRGBO(255, 255, 255, 0.03), Color.fromRGBO(255, 255, 255, 0.03)],
            ),
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
                    'lib/src/image/tags/icon_${widget.id}_${widget.isActivated ? 'on' : 'off'}.png',
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
