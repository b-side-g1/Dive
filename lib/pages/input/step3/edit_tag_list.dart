import 'package:flutter/material.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'file:///D:/android/diary-app/lib/provider/input/tag_provider.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class EditTagList extends StatefulWidget {
  @override
  _EditTagListState createState() => _EditTagListState();
}

class _EditTagListState extends State<EditTagList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Tag> _tags;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(
      BuildContext context, Tag item, Animation<double> animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: SizedBox(
          height: 50.0,
          child: Card(
            child: Center(
              child: Text(item.name, style: textStyle),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._tags = Provider.of<List<Tag>>(context);

    return this._tags == null
        ? Text("로딩중")
        : ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: index == 0
                      ? Row(
                          children: <Widget>[
                            Icon(Icons.add,
                                color: CommonService.hexToColor("#c6ccd4")),
                            SizedBox(width: 8),
                            Text(
                              "새 태그 추가",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      : Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${this._tags[index - 1].name}",
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w400),
                            ),
                            GestureDetector(onTap: () {
                              print("click");
                            }, child: Text("삭제",style: TextStyle(
                              fontSize: 14.0,
                              color: CommonService.hexToColor("#63c7ff")
                            ),))
                          ],
                        ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0.0,),
            itemCount: this._tags.length + 1);

    return Container(
      child: this._tags == null
          ? Text("로딩중")
          : AnimatedList(
              key: _listKey,
              initialItemCount: this._tags.length,
              itemBuilder: (context, index, animation) =>
                  _buildItem(context, _tags[index], animation),
            ),
    );
  }
}
