import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/add_tag_dialog.dart';
import 'package:flutterapp/components/input/step3/model/tag_dialog_entity_model.dart';
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
  List<Tag> _localTags;
  TagProvider _tagProvider;

  List<Tag> _testList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    this._tagProvider.dispose();

    super.dispose();
  }

  Future<TagDialogEntity<String>> _showAddTagDialog(BuildContext context) async {
    print("[edit_tag_list.dart] called _showAddTagDialog!");

    return showDialog<TagDialogEntity<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddTagDialog();
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
                          print("[edit_tag_list.dart] _showAddTagDialog then -> ${value.isConfirm}" );
                          print("[edit_tag_list.dart] _showAddTagDialog then -> ${value.value}" );

                          if(value.isConfirm) {
                            this._tags.add(Tag(id: CommonService.generateUUID(),name: value.value));
                            List<Tag> copys = List.from(this._tags);
                            this._tagProvider.inTags.add(copys);
                          }
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

  @override
  Widget build(BuildContext context) {
    print("[edit_tag_list.dart] #build!");

    this._tags = Provider.of<List<Tag>>(context);
    this._localTags = this._tags;
    this._tagProvider = Provider.of<TagProvider>(context);

    print("build Edit Tag List! ${this._tags}");
    return this._tags == null
        ? Text("로딩중") : this.buildEditTagListView();
  }
}
