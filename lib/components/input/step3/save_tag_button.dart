import 'package:flutter/material.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:provider/provider.dart';

class SaveTagButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final providerTags = Provider.of<List<Tag>>(context);

    return ButtonTheme(
        height: 44,
        child: FlatButton(
          color: CommonService.hexToColor("#63c7ff"),
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop(providerTags);
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
