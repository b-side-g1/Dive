import 'package:flutter/cupertino.dart';
import 'package:flutterapp/commons/static.dart';
import 'package:flutterapp/services/common/common_service.dart';

import 'emotion_tag.dart';

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
            else if (widget.emotions.length == 5) {
              //TODO: Toast 등으로 변경
              return CommonService.showToast("5개까지만 선택이 가능합니다.");
            } else
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
      for (int id = i; id <= 18; id += 6) {
        if (id <= 6) {
          emotionTags.add(EmotionTag(
            id: id,
            title: EmotionNames[id - 1],
            activeColors: [Color.fromRGBO(255, 159, 222, 1), Color.fromRGBO(255, 177, 229, 1)],
            onTap: _onTap(id, EmotionNames[id - 1]),
            isActivated: widget.emotions.where((element) => element['index'] == id).length == 1,
          ));
        } else if (id <= 10) {
          emotionTags.add(EmotionTag(
            id: id,
            title: EmotionNames[id - 1],
            activeColors: [Color.fromRGBO(60, 160, 217, 1), Color.fromRGBO(99, 177, 221, 1)],
            onTap: _onTap(id, EmotionNames[id - 1]),
            isActivated: widget.emotions.where((element) => element['index'] == id).length == 1,
          ));
        } else {
          emotionTags.add(EmotionTag(
            id: id,
            title: EmotionNames[id - 1],
            activeColors: [Color.fromRGBO(86, 113, 210, 1), Color.fromRGBO(100, 119, 188, 1)],
            onTap: _onTap(id, EmotionNames[id - 1]),
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
