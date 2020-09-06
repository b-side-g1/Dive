import 'package:flutter/material.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';

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
    print("[reason_tag_widget.dart] #build! ");

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final container = StateContainer.of(context);
    setState(() {
      this.selectedCount = container.tags.length;
      this.selectedTags = container.tags;

      if(widget.tags != null){
        widget.tags.asMap().forEach((index, tag) => {
            this.selectedTags.forEach((element) {
                if(tag.id == element.id) {
                  this.selecteds[index] = true;
                }
            })
        });
      }
    });

    return widget.tags == null
        ? Text("")
        : SingleChildScrollView(
          child: Wrap(
              spacing: 8.0,
              children: List.generate(widget.tags.length, (index) {
                return ButtonTheme(
                    minWidth: width * 0.19,
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
                            selectedTags.remove(widget.tags[index]);
                            selectedCount--;
                            selecteds[index] = false;
                            selectedTags.removeWhere((tag) => tag.id == widget.tags[index].id);

                          } else {
                            if (selectedCount >= 5) {
                              return CommonService.showToast("5개까지만 선택이 가능합니다.");
                            }
                            selectedTags.add(widget.tags[index]);
                            selectedCount++;
                            selecteds[index] = true;

                          }
                          container.updateTags(selectedTags);
                        });
                      },
                      child: Text(
                        "${widget.tags[index].name}",
                        style: TextStyle(
                          fontSize: width * 0.04,
                        ),
                      ),
                    ));
              })),
        );
  }
}
