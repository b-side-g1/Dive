import 'package:flutter/cupertino.dart';

import 'emotion_tag.dart';

class EmotionTagBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmotionTagBoxState();
}

class _EmotionTagBoxState extends State<EmotionTagBox> {
  List activatedEmotionTagIds = [];

  @override
  Widget build(BuildContext context) {
    _onClick(value) {
      setState(() {
        print('CLICKED!!!!');
        print(value);
//        EmotionTag.isActivated
//            ? activatedEmotionTagIds.add(EmotionTag.EmotionTagId)
//            : activatedEmotionTagIds.removeWhere((element) => element == EmotionTag.EmotionTagId);
//        print(activatedEmotionTagIds);
      });
    }

    return Container(
      width: double.infinity,
      height: 326.1,
      alignment: Alignment.centerLeft,
      child: GridView.count(
        crossAxisSpacing: 9.9,
        mainAxisSpacing: 9.9,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        children: [
          EmotionTag(
            emotionTagId: 1,
            title: '신남',
            activeColor: Color.fromRGBO(255, 159, 222, 1),
            onClick: _onClick,
          ),
          EmotionTag(
              emotionTagId: 7,
              title: '복잡함',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 13,
              title: '무서움',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
          EmotionTag(
              emotionTagId: 2,
              title: '행복함',
              activeColor: Color.fromRGBO(255, 159, 222, 1)),
          EmotionTag(
              emotionTagId: 8,
              title: '생각많음',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 14,
              title: '답답함',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
          EmotionTag(
              emotionTagId: 3,
              title: '기분좋음',
              activeColor: Color.fromRGBO(255, 159, 222, 1)),
          EmotionTag(
              emotionTagId: 9,
              title: '쏘쏘',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 15,
              title: '우울함',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
          EmotionTag(
              emotionTagId: 4,
              title: '편안함',
              activeColor: Color.fromRGBO(255, 159, 222, 1)),
          EmotionTag(
              emotionTagId: 10,
              title: '지루함',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 16,
              title: '당황스러움',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
          EmotionTag(
              emotionTagId: 5,
              title: '사랑돋음',
              activeColor: Color.fromRGBO(255, 159, 222, 1)),
          EmotionTag(
              emotionTagId: 11,
              title: '짜증남',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 17,
              title: '슬픔',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
          EmotionTag(
              emotionTagId: 6,
              title: '설렘',
              activeColor: Color.fromRGBO(255, 159, 222, 1)),
          EmotionTag(
              emotionTagId: 12,
              title: '화남',
              activeColor: Color.fromRGBO(60, 160, 217, 1)),
          EmotionTag(
              emotionTagId: 18,
              title: '아픔',
              activeColor: Color.fromRGBO(86, 113, 210, 1)),
        ],
      ),
    );
  }
}
