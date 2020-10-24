import 'dart:async';

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
import 'package:Dive/pages/daily_page.dart';
import 'package:Dive/provider/input/tag_provider.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:Dive/services/daily/daily_service.dart';
import 'package:Dive/services/emotion/emotion_service.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:Dive/services/tag/tag_service.dart';

class InputPageStep3 extends StatefulWidget {
  String description;

  InputPageStep3({Key key, String description})
      : description = description ?? "",
        super(key: key);

  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
  TagProvider tagProvider;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Tag> _tags;
  TagService _tagService = TagService();
  String description;

  Future<List<Tag>> createEditTagDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return EditTagDialog();
        });
  }

  @override
  void initState() {
    _tagService.selectAllTags().then((tags) {
      setState(() {
        this._tags = tags;
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
    return Container(
        child: Center(
            child: Text(
      "그렇게 느끼는 이유는...",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 6.3,
          fontWeight: FontWeight.w700,
          color: Colors.white),
    )));
  }

  Widget toolBarWidget() {

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "이유태그",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 5.5,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () async {
            createEditTagDialog(context).then((_) {
              setState(() {
                _tagService.selectAllTags().then((tags) {
                  setState(() {
                    this._tags = tags;
                  });
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
              SizedBox(
                width: 3,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
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
    ));
  }

  Widget reasonTagList() {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.23,
      alignment: Alignment.centerLeft,
      child: ReasonTagWidget(
        tags: this._tags,
      ),
    );
  }

  Widget writeReasonTitle() {
    return Container(
        child: Row(
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
    ));
  }

  Widget writeReasonField() {
    return Container(
        child: TextFormField(
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {},
          onTap: () {
//            Timer(
//                Duration(milliseconds: 300),
//                () => _scrollController
//                    .jumpTo(_scrollController.position.maxScrollExtent));
          },
          controller: _textEditingController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          cursorColor: CommonService.hexToColor("#34b7eb"),
          style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeHorizontal * 4),
          decoration: new InputDecoration(
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "더 자세히 떠올려보자"),
        ));
  }

  _saveEmotions(List<Emotion> emotions, String recordId) async {
//    print('====Called save emotions====');
    return Future.wait(emotions.map((emotion) async {
      return EmotionService().insertRecordHasEmotion(RecordHasEmotion(
          recordId: recordId,
          emotionId: emotion.id,
          createdAt: DateTime.now().toString()));
    }));
  }

  _saveTags(List<Tag> tags, String recordId) async {
//    print('====Called save tags====');
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ButtonTheme(
          minWidth: 316,
          height: 60,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            color: CommonService.hexToColor("#63c7ff"),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            onPressed: () async {
              if (container.record == null) {
                String id = CommonService.generateUUID();
                Iterable<Future<dynamic>> futures = [
                  RecordService().insertRecord(Record(
                      id: id,
                      score: container.score,
                      dailyId: await DailyService()
                          .getDailyByTimestamp(
                              DateTime.now().millisecondsSinceEpoch, true)
                          .then((value) => value.id),
                      emotions: container.emotions,
                      tags: container.tags,
                      createdAt: container.selectedTime,
                      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
                      updatedAt: DateTime.now().toString(),
                      description: _textEditingController.text)),
                  this._saveEmotions(container.emotions, id),
                  this._saveTags(container.tags, id)
                ];
                await Future.wait(futures);
              } else {
                Record record = container.record;
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
                  RecordService().deleteRecord(recordParam.id),
                  RecordService().insertRecord(recordParam),
                  TagService().deleteRecordHasTagByRecordId(recordParam.id),
                  EmotionService()
                      .deleteRecordHasEmotionByRecordId(recordParam.id),
                  this._saveEmotions(container.emotions, recordParam.id),
                  this._saveTags(container.tags, recordParam.id)
                ];
                await Future.wait(futures).then(
                    (value) => CommonService.showToast("감정 기록이 수정되었습니다."));
              }

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StateContainer(child: DailyPage())));
            },
            child: Text(
              (container.record == null) ?  "기록하기" : "수정하기",
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build input_page_step3');

    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
            height: height,
            padding: EdgeInsets.only(top: 100, bottom: 20, left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 1, child: titleWidget()),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      toolBarWidget(),
                      reasonTagList()
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      writeReasonTitle(),
                      writeReasonField()
                    ],
                  ),
                ),
                recordButton(),
              ],
            )),
      ),
    );
  }
}
