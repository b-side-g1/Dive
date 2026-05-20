import 'package:flutter/material.dart';
import 'package:Dive/components/input/step3/add_tag_dialog.dart';
import 'package:Dive/components/input/step3/model/tag_dialog_entity_model.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:Dive/services/tag/tag_service.dart';

class EditTagList extends StatefulWidget {
  const EditTagList({super.key});

  @override
  _EditTagListState createState() => _EditTagListState();
}

class _EditTagListState extends State<EditTagList> {
  List<Tag>? _tags;
  final TagService _tagService = TagService();

  @override
  void initState() {
    super.initState();

    _tagService.selectAllTags().then((tags) {
      setState(() {
        _tags = tags;
      });
    });
  }

  Future<TagDialogEntity<String>?> _showAddTagDialog(
      BuildContext context) async {
    return showDialog<TagDialogEntity<String>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AddTagDialog();
      },
    );
  }

  Widget buildEditTagListView() {
    final width = MediaQuery.of(context).size.width;
    final tags = _tags ?? const <Tag>[];

    return SizedBox(
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
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _showAddTagDialog(context).then((value) {
                                if (value != null &&
                                    value.isConfirm &&
                                    value.value != null) {
                                  final nameParam =
                                      (value.value as String).split(" ").join("");
                                  final nowDate = DateTime.now().toString();
                                  Tag tagParam = Tag(
                                      id: CommonService.generateUUID(),
                                      name: nameParam,
                                      createdAt: nowDate);
                                  Tag? exist;
                                  for (final tag
                                      in (_tags ?? const <Tag>[])) {
                                    if (tag.name == tagParam.name) {
                                      exist = tag;
                                      break;
                                    }
                                  }
                                  if (exist == null) {
                                    _tagService.insertTag(tagParam).then((_) {
                                      _tagService.selectAllTags().then((tags) {
                                        setState(() {
                                          _tags = tags;
                                        });
                                      });
                                    });
                                  }
                                }
                              });
                            },
                            child: Text(
                              "새 태그 추가",
                              style: TextStyle(
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${tags[index - 1].name}",
                            style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w400),
                          ),
                          GestureDetector(
                              onTap: () {
                                _tagService.deleteTag(tags[index - 1]).then((_) {
                                  _tagService.selectAllTags().then((tags) {
                                    setState(() {
                                      _tags = tags;
                                    });
                                  });
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
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0.0),
          itemCount: tags.length + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tags == null ? const Text("로딩중") : buildEditTagListView();
  }
}
