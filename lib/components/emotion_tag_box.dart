import 'package:flutter/cupertino.dart';

import 'emotion_tag.dart';

List emotionNames = [
  '신남',
  '행복함',
  '기분좋음',
  '편안함',
  '사랑돋음',
  '설렘',
  '복잡함',
  '생각많음',
  '지루함',
  '쏘쏘',
  '짜증남',
  '화남',
  '무서움',
  '답답함',
  '우울함',
  '당황스러움',
  '슬픔',
  '아픔'
];

class EmotionTagBox extends StatefulWidget {
  List emotions;

  EmotionTagBox({Key key, this.emotions}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmotionTagBoxState();
}

class _EmotionTagBoxState extends State<EmotionTagBox> {
//  List _activatedEmotionTagIds = [];
//
//  get activatedEmotionTagIds => _activatedEmotionTagIds;

  @override
  Widget build(BuildContext context) {
    _onTap(int index, String name) {
      return () => setState(() {
            if (widget.emotions.singleWhere(
                    (element) => element['index'] == index,
                    orElse: () => null) !=
                null)
              widget.emotions
                  .removeWhere((element) => element['index'] == index);
            else
              widget.emotions.add({'index': index, 'name': name});
          });
//      return () => setState(() {
//            _activatedEmotionTagIds.contains()
//                ? _activatedEmotionTagIds
//                    .removeWhere((element) => element == tagId)
//                : _activatedEmotionTagIds.add(tagId);
//            print(activatedEmotionTagIds);
//          });
    }

    List<EmotionTag> emotionTags = [];
    for (int i = 1; i <= 6; i++) {
      for(int id = i; id <= 18; id += 6) {
        if (id <= 6) {
          emotionTags.add(EmotionTag(
            id: id,
            title: emotionNames[id - 1],
            activeColor: Color.fromRGBO(255, 159, 222, 1),
            onTap: _onTap(id, emotionNames[id - 1]),
            isActivated: widget.emotions.where((element) => element['index'] == id).length == 1,
          ));
        } else if (id <= 10) {
          emotionTags.add(EmotionTag(
            id: id,
            title: emotionNames[id - 1],
            activeColor: Color.fromRGBO(60, 160, 217, 1),
            onTap: _onTap(id, emotionNames[id - 1]),
            isActivated: widget.emotions.where((element) => element['index'] == id).length == 1,
          ));
        } else {
          emotionTags.add(EmotionTag(
            id: id,
            title: emotionNames[id - 1],
            activeColor: Color.fromRGBO(86, 113, 210, 1),
            onTap: _onTap(id, emotionNames[id - 1]),
            isActivated: widget.emotions.where((element) => element['index'] == id).length == 1,
          ));
        }
      }
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
        children: emotionTags,
      ),
    );
  }
}
