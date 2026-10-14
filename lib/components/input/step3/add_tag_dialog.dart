import 'package:flutter/material.dart';
import 'package:Dive/components/input/step3/model/tag_dialog_entity_model.dart';
import 'package:Dive/services/common/common_service.dart';

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({super.key});

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final addTagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('새 태그 추가')),
      content: TextFormField(
        maxLength: 10,
        controller: addTagController,
        cursorColor: CommonService.hexToColor("#34b7eb"),
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CommonService.hexToColor("#d0d5d9"), width: 1.0)),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "태그를 추가하세요 (최대 10자)"),
      ),
      actions: <Widget>[
        SizedBox(
            width: 260,
            child: Divider(color: CommonService.hexToColor("#d0d5d9"))),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  final entity =
                      TagDialogEntity<String>(isConfirm: false, value: null);
                  Navigator.of(context).pop(entity);
                },
                child: Text(
                  "취소",
                  style: TextStyle(
                      fontSize: 15.0,
                      color: CommonService.hexToColor("#111111")),
                ),
              ),
              SizedBox(
                  height: 47,
                  child: VerticalDivider(
                      color: CommonService.hexToColor("#d0d5d9"))),
              TextButton(
                onPressed: () {
                  String inputTag = addTagController.text;
                  final entity = TagDialogEntity<String>(
                      isConfirm: true, value: inputTag);
                  Navigator.of(context).pop(entity);
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
  }

  @override
  void dispose() {
    addTagController.dispose();
    super.dispose();
  }
}
