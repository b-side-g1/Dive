import 'package:flutter/material.dart';

class EmotionTag extends StatefulWidget {
  final String title;
  final int id;
  final double width;
  final double height;
  final VoidCallback onTap;
  final List<Color> activeColors;
  final bool isActivated;

  const EmotionTag({
    super.key,
    required this.id,
    required this.title,
    required this.onTap,
    required this.activeColors,
    required this.isActivated,
    this.width = 34,
    this.height = 34,
  });

  @override
  _EmotionTagState createState() => _EmotionTagState();
}

class _EmotionTagState extends State<EmotionTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        onVerticalDragStart: (detail) {
          widget.onTap();
        },
        child: Container(
          height: widget.width,
          width: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isActivated
                  ? widget.activeColors
                  : const [
                      Color.fromRGBO(255, 255, 255, 0.03),
                      Color.fromRGBO(255, 255, 255, 0.03)
                    ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(9.9)),
          ),
          child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'lib/src/image/tags/icon_${widget.id}_${widget.isActivated ? 'on' : 'off'}.png',
                    height: 16.7 / widget.height * (100 + 9),
                    width: 16.7 / widget.width * (100 + 9),
                  ),
                  Text(
                    widget.title,
                    style:
                        const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              )),
        ));
  }
}
