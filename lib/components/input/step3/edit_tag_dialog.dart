import 'package:flutter/material.dart';
import 'package:Dive/components/input/step3/edit_tag_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditTagDialog extends StatelessWidget {
  const EditTagDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "태그편집",
            style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w700,
                fontFamily: "NotoSans"),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset('assets/images/svg/btn_x.svg'))
        ],
      ),
      content: const EditTagList(),
      actions: const <Widget>[],
    );
  }
}
