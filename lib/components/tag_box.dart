import 'package:flutter/material.dart';

import 'tag.dart';

class TagBox extends StatefulWidget {
  final String title;
  final List<String> tags;
  final int columnNumber;

  const TagBox(
      {super.key,
      required this.tags,
      required this.title,
      required this.columnNumber});

  @override
  _TagBoxState createState() => _TagBoxState();
}

class _TagBoxState extends State<TagBox> {
  List<Row> tagRows = [];

  @override
  Widget build(BuildContext context) {
    tagRows = [];
    var tagPaddings = widget.tags.map((e) => Tag(title: e)).toList();
    for (int i = 0; i < tagPaddings.length / widget.columnNumber; i++) {
      if (i * widget.columnNumber + widget.columnNumber < tagPaddings.length) {
        tagRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textBaseline: TextBaseline.alphabetic,
          children: tagPaddings
              .getRange(i * widget.columnNumber,
                  i * widget.columnNumber + widget.columnNumber)
              .toList(),
        ));
      } else {
        tagRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textBaseline: TextBaseline.alphabetic,
          children: tagPaddings
              .getRange(i * widget.columnNumber, tagPaddings.length)
              .toList(),
        ));
      }
    }
    return Column(children: [Text(widget.title), Column(children: tagRows)]);
  }
}
