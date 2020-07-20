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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<List<Tag>>(context);

    return GridView.count(
        padding: EdgeInsets.all(0),
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 4),
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        children: List.generate(tags.length, (index) {
          return ButtonTheme(
              minWidth: 49,
              height:30,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                color: CommonService.hexToColor("#63c7ff"),
                textColor: Colors.white,
                onPressed: () {},
                child: Text(
                  "${tags[index].name}",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ));
        }));
  }
}
