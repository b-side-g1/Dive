import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/add_tag_dialog.dart';
import 'package:flutterapp/components/input/step3/model/tag_dialog_entity_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class EditTagList extends StatefulWidget {
  @override
  _EditTagListState createState() => _EditTagListState();
}

class _EditTagListState extends State<EditTagList> {
  List<Tag> _tags;
  TagService _tagService = TagService();

  @override
  void initState() {
    super.initState();

    _tagService.selectAllTags().then((tags) {
      setState(() {
        this._tags = tags;
      });
    });
  }

  @override
  void dispose() {
    print("[edit_tag_list].dart #dispose!");
    super.dispose();
  }

  Future<TagDialogEntity<String>> _showAddTagDialog(
      BuildContext context) async {
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
    final width = MediaQuery.of(context).size.width;

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
                                print(
                                    "[edit_tag_list.dart] _showAddTagDialog then -> ${value.isConfirm}");
                                print(
                                    "[edit_tag_list.dart] _showAddTagDialog then -> ${value.value}");

                                if (value.isConfirm) {
                                  Tag tagParam = Tag(
                                    id: CommonService.generateUUID(),
                                    name: value.value
                                  );
                                  _tagService.insertTag(tagParam).then((_) {
                                      _tagService.selectAllTags().then((tags) {
                                        setState(() {
                                          this._tags = tags;
                                        });
                                      } );
                                  });
                                }
                              });
                            },
                            child: Text(
                              "새 태그 추가",
                              style: TextStyle(
                                  fontSize: width * 0.045, fontWeight: FontWeight.w400),
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
                                fontSize: width * 0.045, fontWeight: FontWeight.w400),
                          ),
                          GestureDetector(
                              onTap: () {
                                _tagService.deleteTag(this._tags[index - 1]).then((_) {
                                  _tagService.selectAllTags().then((tags) {
                                    setState(() {
                                      this._tags = tags;
                                    });
                                  } );
                                });
                              },
                              child: Text(
                                "삭제",
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: CommonService.hexToColor("#63c7ff")),
                              ))
                        ],
                      ));
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 0.0,
              ),
          itemCount: this._tags.length + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[edit_tag_list.dart] #build!");
    return this._tags == null ? Text("로딩중") : this.buildEditTagListView();
  }
}
