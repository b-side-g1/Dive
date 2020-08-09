import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class ReasonTagWidget extends StatefulWidget {
  List<Tag> tags;

  ReasonTagWidget({Key key, this.tags}) : super(key: key);

  @override
  _BuildReasonTagState createState() => _BuildReasonTagState();
}

class _BuildReasonTagState extends State<ReasonTagWidget> {
  List<bool> selecteds;
  List<Tag> selectedTags;
  List<Tag> selectTag;

  int selectedCount;

  @override
  void initState() {
    super.initState();
    this.selectedCount = 0;
    this.selecteds = List(50);
    this.selecteds =
        this.selecteds.map((e) => e == true ? true : false).toList();
    this.selectedTags = List();
  }

  @override
  Widget build(BuildContext context) {

//        this.tags = Provider.of<List<Tag>>(context);
    print("[reason_tag_widget.dart] #build! ");

    final container = StateContainer.of(context);
    return widget.tags == null
        ? Text("")
        : GridView.count(
            padding: EdgeInsets.all(0),
            crossAxisCount: 4,
            shrinkWrap: true,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 4),
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            children: List.generate(widget.tags.length, (index) {
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
                        if (selecteds[index]) {
                          selectedCount--;
                          selecteds[index] = false;
                        } else {
                          if (selectedCount >= 5) {
                            return CommonService.showToast("5개까지만 선택이 가능합니다.");
                          }
                          selectedTags.add(widget.tags[index]);
                          selectedCount++;
                          selecteds[index] = true;

                          container.updateTags(selectedTags);
                        }
                      });
                    },
                    child: Text(
                      "${widget.tags[index].name}",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ));
            }));
  }
}
