import 'package:flutter/cupertino.dart';

import 'Tag.dart';

class TagBox extends StatefulWidget {
  String title;
  List<String> tags;
  int columnNumber;

  TagBox({Key key, this.tags, this.title, this.columnNumber}) : super(key: key);

  @override
  _TagBoxState createState() {
    return _TagBoxState();
  }
}

class _TagBoxState extends State<TagBox> {
  List<Row> tagRows;

  @override
  Widget build(BuildContext context) {
    tagRows = [];
    var tagPaddings = widget.tags
        .map((e) => new Tag(title: e, isSelected: false,))
        .toList();
    for (int i = 0; i < tagPaddings.length / widget.columnNumber; i++) {
      if (i * widget.columnNumber + widget.columnNumber < tagPaddings.length) {
        this.tagRows.add(new Row(
              children: tagPaddings
                  .getRange(i * widget.columnNumber,
                      i * widget.columnNumber + widget.columnNumber)
                  .toList(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textBaseline: TextBaseline.alphabetic,
            ));
      } else {
        this.tagRows.add(new Row(
              children: tagPaddings
                  .getRange(i * widget.columnNumber, tagPaddings.length)
                  .toList(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textBaseline: TextBaseline.alphabetic,
            ));
      }
    }
    return Column(children: [Text(widget.title), Column(children: tagRows)]);
  }
}
