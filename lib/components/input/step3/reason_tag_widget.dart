import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:provider/provider.dart';

class ReasonTagWidget extends StatefulWidget {
  @override
  _BuildReasonTagState createState() => _BuildReasonTagState();
}

class _BuildReasonTagState extends State<ReasonTagWidget> {
  List<bool> selecteds;
  List<Tag> tags;

  @override
  void initState() {
    super.initState();
    this.selecteds = List(50);
    this.selecteds = this.selecteds.map((e) => e == true ? true : false).toList();
  }

  @override
  Widget build(BuildContext context) {
    print("Build!");
    this.tags = Provider.of<List<Tag>>(context);

    return GridView.count(
        padding: EdgeInsets.all(0),
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 4),
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        children: List.generate(this.tags.length, (index) {
          return ButtonTheme(
              minWidth: 49,
              height: 30,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                color: selecteds[index]
                    ? CommonService.hexToColor("#63c7ff")
                    : CommonService.hexToColor("#2f4262"),
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    selecteds[index] = selecteds[index] ? false : true;
                  });
                },
                child: Text(
                  "${this.tags[index].name}",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ));
        }));
  }
}
