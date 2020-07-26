import 'package:flutter/material.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:provider/provider.dart';

class SaveTagButton extends StatelessWidget {

  List<Tag> _tags;

  @override
  Widget build(BuildContext context) {

    this._tags = Provider.of<List<Tag>>(context);

    return ButtonTheme(
        height: 44,
        child: FlatButton(
          color: CommonService.hexToColor("#63c7ff"),
          textColor: Colors.white,
          onPressed: () {
            for(Tag i in this._tags) {
              print("[save_tag_button.dart] #onPressed! ${i.name}");
            }
//            Navigator.of(context).pop(this._tags);
          },
          child: Text(
            "저장",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ));
  }
}
