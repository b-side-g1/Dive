import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/edit_tag_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class EditTagDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final provider = Provider.of<TagProvider>(context);
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "태그편집",
            style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w700,fontFamily: "NotoSans"),
          ),
          SvgPicture.asset('assets/images/svg/btn_x.svg')
        ],
      ),
      content: EditTagList(),
//      content: StreamProvider.value(
//          initialData: [Tag(id: '1253315', name: 'asdf24')],
//            value: provider.tags,
//          child: EditTagList()),
      actions: <Widget>[
//        SizedBox(
//            width: double.maxFinite,
//            child: StreamProvider.value(
//                value: provider.tags, child: SaveTagButton()))
      ],
    );
  }
}
