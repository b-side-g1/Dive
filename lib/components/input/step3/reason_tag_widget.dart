import 'package:flutter/material.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';

class ReasonTagWidget extends StatefulWidget {
  final List<Tag>? tags;

  const ReasonTagWidget({super.key, this.tags});

  @override
  _BuildReasonTagState createState() => _BuildReasonTagState();
}

class _BuildReasonTagState extends State<ReasonTagWidget> {
  List<bool> selecteds = List<bool>.filled(50, false);
  List<Tag> selectedTags = [];
  List<Tag> selectTag = [];

  int selectedCount = 0;

  @override
  void initState() {
    super.initState();
    selectedCount = 0;
    selecteds = List<bool>.filled(50, false);
    selectedTags = [];
  }

  @override
  Widget build(BuildContext context) {
    print("[reason_tag_widget.dart] #build! ");

    final scrollController = ScrollController();

    final width = MediaQuery.of(context).size.width;

    final container = StateContainer.of(context);
    setState(() {
      selectedCount = container.tags.length;
      selectedTags = container.tags;

      if (widget.tags != null) {
        widget.tags!.asMap().forEach((index, tag) {
          for (final element in selectedTags) {
            if (tag.id == element.id) {
              selecteds[index] = true;
            }
          }
        });
      }
    });

    return widget.tags == null
        ? const Text("")
        : Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                  spacing: 5.0,
                  children: List.generate(widget.tags!.length, (index) {
                    return ButtonTheme(
                        minWidth: width * 0.19,
                        height: 30,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            backgroundColor: selecteds[index]
                                ? CommonService.hexToColor("#63c7ff")
                                : CommonService.hexToColor("#2f4262"),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (selecteds[index]) {
                                selectedTags.remove(widget.tags![index]);
                                selectedCount--;
                                selecteds[index] = false;
                                selectedTags.removeWhere(
                                    (tag) => tag.id == widget.tags![index].id);
                              } else {
                                if (selectedCount >= 5) {
                                  CommonService.showToast("5개까지만 선택이 가능합니다.");
                                  return;
                                }
                                selectedTags.add(widget.tags![index]);
                                selectedCount++;
                                selecteds[index] = true;
                              }
                              container.updateTags(selectedTags);
                            });
                          },
                          child: Text(
                            "${widget.tags![index].name}",
                            style: TextStyle(
                              fontSize: width * 0.04,
                            ),
                          ),
                        ));
                  })),
            ),
          );
  }
}
