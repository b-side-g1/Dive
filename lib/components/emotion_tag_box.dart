import 'package:flutter/material.dart';
import 'package:Dive/commons/static.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/services/common/common_service.dart';

import 'emotion_tag.dart';

class EmotionTagBox extends StatefulWidget {
  final List<Emotion> emotions;

  const EmotionTagBox({super.key, required this.emotions});

  @override
  State<StatefulWidget> createState() => _EmotionTagBoxState();
}

class _EmotionTagBoxState extends State<EmotionTagBox> {
  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);

    VoidCallback onTap(int id, String name) {
      return () => setState(() {
            Emotion? match;
            for (final element in widget.emotions) {
              if (element.id == id.toString()) {
                match = element;
                break;
              }
            }
            if (match != null) {
              widget.emotions
                  .removeWhere((element) => element.id == id.toString());
            } else if (widget.emotions.length == 5) {
              CommonService.showToast("5개까지만 선택이 가능합니다.");
              return;
            } else {
              widget.emotions.add(Emotion(id: id.toString(), name: name));
            }
            final emotionsParam = widget.emotions
                .map((e) => Emotion(id: e.id, name: e.name))
                .toList();
            container.updateEmotions(emotionsParam);
          });
    }

    List<EmotionTag> emotionTags = [];
    for (int i = 1; i <= 6; i++) {
      for (int id = i; id <= 18; id += 6) {
        late List<Color> colors;
        if (id <= 6) {
          colors = const [
            Color.fromRGBO(255, 159, 222, 1),
            Color.fromRGBO(255, 177, 229, 1)
          ];
        } else if (id <= 10) {
          colors = const [
            Color.fromRGBO(60, 160, 217, 1),
            Color.fromRGBO(99, 177, 221, 1)
          ];
        } else {
          colors = const [
            Color.fromRGBO(86, 113, 210, 1),
            Color.fromRGBO(100, 119, 188, 1)
          ];
        }
        emotionTags.add(EmotionTag(
          id: id,
          title: EmotionNames[id - 1],
          activeColors: colors,
          onTap: onTap(id, EmotionNames[id - 1]),
          isActivated: widget.emotions
                  .where((element) => element.id == id.toString())
                  .length ==
              1,
        ));
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
