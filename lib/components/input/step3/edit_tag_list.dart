import 'package:flutter/material.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:provider/provider.dart';

class EditTagList extends StatefulWidget {
  @override
  _EditTagListState createState() => _EditTagListState();
}

class _EditTagListState extends State<EditTagList> {
  List<Tag> _tags;
  TagProvider _tagProvider;
  final addTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    this.addTagController.dispose();
    super.dispose();
  }

  Future<String> _showAddTagDialog(BuildContext context) async {
    final tagProvider = Provider.of<TagProvider>(context);

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('새 태그 추가')),
          content: TextFormField(
            controller: this.addTagController,
            cursorColor: CommonService.hexToColor("#34b7eb"),
            decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CommonService.hexToColor("#d0d5d9"),
                        width: 1.0)),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "태그를 추가하세요 (최대 10자)"),
          ),
          actions: <Widget>[
            Container(
                width: 260,
                child: Divider(color: CommonService.hexToColor("#d0d5d9"))),
            SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "취소",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: CommonService.hexToColor("#111111")),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                      height: 47,
                      child: VerticalDivider(
                          color: CommonService.hexToColor("#d0d5d9"))),
                  FlatButton(
                    onPressed: () {
                      String inputTag = this.addTagController.text.toString();
//                      tagProvider.inAddTag.add(Tag(
//                          id: CommonService.generateUUID(), name: inputTag));
                      Navigator.of(context).pop(inputTag);
                    },
                    child: Text(
                      "추가",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: CommonService.hexToColor("#63c7ff")),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildEditTagListView() {
    return Container(
      width: 280,
      height: 324,
      child: ListView.separated(
          shrinkWrap: true,
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
                    GestureDetector(
                      onTap: () {
                        _showAddTagDialog(context).then((value) {
                          this._tagProvider.inAddTag.add(Tag(id: CommonService.generateUUID(),name: value));
                        });
                      },
                      child: Text(
                        "새 태그 추가",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${this._tags[index - 1].name}",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                        onTap: () {
                          print("click");
                        },
                        child: Text(
                          "삭제",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CommonService.hexToColor(
                                  "#63c7ff")),
                        ))
                  ],
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(
            height: 0.0,
          ),
          itemCount: this._tags.length + 1),
    );
  }

  Widget buildTestEditTagListView() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    this._tags = Provider.of<List<Tag>>(context);
    this._tagProvider = Provider.of<TagProvider>(context);


    print("build Edit Tag List! ${this._tags}");
    return this._tags == null
        ? Text("로딩중") : this.buildEditTagListView();
  }
}
