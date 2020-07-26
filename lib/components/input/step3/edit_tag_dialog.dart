import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/edit_tag_list.dart';
import 'package:flutterapp/components/input/step3/save_tag_button.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:provider/provider.dart';

class EditTagDialog extends StatelessWidget {
  List<Tag> tags;

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TagProvider>(context);

    return AlertDialog(
      title: Center(
        child: Text(
          "태그편집",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
        ),
      ),
      content: StreamProvider.value(
          initialData: [Tag(id: '1253315', name: 'asdf24')],
            value: provider.tags,
          child: EditTagList()),
      actions: <Widget>[
        SizedBox(
            width: double.maxFinite,
            child: StreamProvider.value(
                value: provider.tags, child: SaveTagButton()))
      ],
    );
  }
}
