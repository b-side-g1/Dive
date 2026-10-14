import 'package:Dive/controller/diary_tab_controller.dart';
import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Dive/components/input/step3/edit_tag_dialog.dart';
import 'package:Dive/components/input/step3/reason_tag_widget.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/models/record_has_emotion.dart';
import 'package:Dive/models/record_has_tag.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:Dive/services/daily/daily_service.dart';
import 'package:Dive/services/emotion/emotion_service.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:Dive/services/tag/tag_service.dart';

class InputPageStep3 extends StatefulWidget {
  final String description;

  InputPageStep3({super.key, String? description})
      : description = description ?? "";

  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Tag>? _tags;
  final TagService _tagService = TagService();

  Future<dynamic> createEditTagDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const EditTagDialog();
        });
  }

  @override
  void initState() {
    super.initState();
    _tagService.selectAllTags().then((tags) {
      setState(() {
        _tags = tags;
      });
    });
    _textEditingController.text = widget.description;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget titleWidget() {
    return Center(
        child: Text(
      "그렇게 느끼는 이유는...",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 6.3,
          fontWeight: FontWeight.w700,
          color: Colors.white),
    ));
  }

  Widget toolBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "이유태그",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 5.5,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () async {
            createEditTagDialog(context).then((_) {
              _tagService.selectAllTags().then((tags) {
                setState(() {
                  _tags = tags;
                });
              });
            });
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.edit,
                color: Colors.grey,
                size: SizeConfig.blockSizeHorizontal * 5,
              ),
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "태그편집",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget reasonTagList() {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.23,
      alignment: Alignment.centerLeft,
      child: ReasonTagWidget(tags: _tags),
    );
  }

  Widget writeReasonTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "이유적기",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 5.5,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ],
    );
  }

  Widget writeReasonField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: _textEditingController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      cursorColor: CommonService.hexToColor("#34b7eb"),
      style: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.blockSizeHorizontal * 4),
      decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: "더 자세히 떠올려보자"),
    );
  }

  Future<List<RecordHasEmotion>> _saveEmotions(
      List<Emotion> emotions, String recordId) {
    return Future.wait(emotions.map((emotion) async {
      return EmotionService().insertRecordHasEmotion(RecordHasEmotion(
          recordId: recordId,
          emotionId: emotion.id,
          createdAt: DateTime.now().toString()));
    }));
  }

  Future<List<RecordHasTag>> _saveTags(List<Tag> tags, String recordId) {
    return Future.wait(tags.map((tag) async {
      return TagService().insertRecordHasTag(RecordHasTag(
          recordId: recordId,
          tagId: tag.id,
          createdAt: DateTime.now().toString()));
    }));
  }

  Widget recordButton() {
    final container = StateContainer.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
          width: 316,
          height: 60,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              backgroundColor: CommonService.hexToColor("#63c7ff"),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
            ),
            onPressed: () async {
              if (container.record == null) {
                String id = CommonService.generateUUID();
                final daily = await DailyService().getDailyByTimestamp(
                    DateTime.now().millisecondsSinceEpoch, true);
                final dailyId = daily?.id;
                Iterable<Future<dynamic>> futures = [
                  RecordService().insertRecord(Record(
                      id: id,
                      score: container.score,
                      dailyId: dailyId,
                      emotions: container.emotions,
                      tags: container.tags,
                      createdAt: container.selectedTime,
                      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
                      updatedAt: DateTime.now().toString(),
                      description: _textEditingController.text)),
                  _saveEmotions(container.emotions, id),
                  _saveTags(container.tags, id)
                ];
                await Future.wait(futures);
              } else {
                Record record = container.record!;
                Record recordParam = Record(
                    id: record.id,
                    score: container.score,
                    dailyId: record.dailyId,
                    emotions: container.emotions,
                    tags: container.tags,
                    createdAt: container.selectedTime,
                    createdTimestamp: record.createdTimestamp,
                    updatedAt: DateTime.now().toString(),
                    description: _textEditingController.text);

                Iterable<Future<dynamic>> futures = [
                  RecordService().deleteRecord(recordParam.id!),
                  RecordService().insertRecord(recordParam),
                  TagService().deleteRecordHasTagByRecordId(recordParam.id!),
                  EmotionService()
                      .deleteRecordHasEmotionByRecordId(recordParam.id!),
                  _saveEmotions(container.emotions, recordParam.id!),
                  _saveTags(container.tags, recordParam.id!)
                ];
                await Future.wait(futures).then(
                    (value) => CommonService.showToast("감정 기록이 수정되었습니다."));
              }
              if (!context.mounted) return;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StateContainer(
                          child: const DiaryTabController())));
            },
            child: Text(
              (container.record == null) ? "기록하기" : "수정하기",
              style: const TextStyle(fontSize: 22.0),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
            height: height,
            padding: const EdgeInsets.only(
                top: 100, bottom: 20, left: 25, right: 25),
            child: Column(
              children: <Widget>[
                Expanded(flex: 1, child: titleWidget()),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [toolBarWidget(), reasonTagList()],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [writeReasonTitle(), writeReasonField()],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: recordButton(),
                ),
              ],
            )),
      ),
    );
  }
}
