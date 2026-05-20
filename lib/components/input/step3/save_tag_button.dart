import 'package:flutter/material.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:provider/provider.dart';

class SaveTagButton extends StatelessWidget {
  const SaveTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    final providerTags = Provider.of<List<Tag>>(context);

    return SizedBox(
        height: 44,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: CommonService.hexToColor("#63c7ff"),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(providerTags);
          },
          child: const Text(
            "저장",
            style: TextStyle(fontSize: 16.0),
          ),
        ));
  }
}
