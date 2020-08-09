import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/edit_tag_dialog.dart';
import 'package:flutterapp/components/input/step3/reason_tag_widget.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_has_emotion.dart';
import 'package:flutterapp/models/record_has_tag.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/pages/daily_page.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/emotion/emotion_service.dart';
import 'package:flutterapp/services/record/record_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';

class InputPageStep3 extends StatefulWidget {
  InputPageStep3({Key key}) : super(key: key);

  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
  TagProvider tagProvider;
  TextEditingController _textEditingController = TextEditingController();
  List<Tag> _tags;
  TagService _tagService = TagService();

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
  }

  Widget titleWidget() {
    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(top: 110, left: 70, right: 70),
        child: Center(
            child: Text(
          "그렇게 느끼는 이유는...",
          style: TextStyle(
              fontSize: width * 0.08, fontWeight: FontWeight.w700, color: Colors.white),
        )));
  }

  Widget toolBarWidget() {
    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "이유태그",
              style: TextStyle(
                  fontSize: width * 0.07,
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
                  Icon(Icons.edit, color: Colors.grey,size: width * 0.05,),
                  SizedBox(
                    width: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      "태그편집",
                      style: TextStyle(
                          fontSize: width * 0.05,
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
      height: height * 0.18,
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: ReasonTagWidget(
        tags: this._tags,
      ),
    );
  }

  Widget writeReasonTitle() {

    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "이유적기",
              style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget writeReasonField() {

    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(top: 13, left: 20, right: 20),
        child: TextFormField(
          controller: _textEditingController,
          cursorColor: CommonService.hexToColor("#34b7eb"),
          style: TextStyle(color: Colors.white,fontSize: width * 0.04),
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

  Widget recordButton() {
    final container = StateContainer.of(context);

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
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
              if (container.score == null) {
                container.score = 50;
              }

              int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
              Daily daily =
                  await DailyService().getDailyByTimestamp(currentTimeStamp);

              String dailyId = daily.id;

              Record recordParam = Record(
                  id: CommonService.generateUUID(),
                  score: container.score,
                  dailyId: dailyId,
                  emotions: container.emotions,
                  tags: container.tags,
                  createdAt: DateTime.now().toString(),
                  updatedAt: DateTime.now().toString(),
                  description: _textEditingController.text);

              await RecordService().insertRecord(recordParam);

              if (container.tags != null) {
                container.tags.forEach((tag) async {
                  RecordHasTag recordHasTagParam = RecordHasTag(
                      recordId: recordParam.id,
                      tagId: tag.id,
                      createdAt: DateTime.now().toString());
                  print("recordHasTagParam -> ${recordHasTagParam.toJson()}");
                  await TagService().insertRecordHasTag(recordHasTagParam);
                });
              }
              if (container.emotions != null) {
                container.emotions.forEach((emotion) async {
                  RecordHasEmotion recordHasEmotion = RecordHasEmotion(
                      recordId: recordParam.id,
                      emotionId: emotion.id,
                      createdAt: DateTime.now().toString());
                  await EmotionService()
                      .insertRecordHasEmotion(recordHasEmotion);
                });
              }

              CommonService.showToast("당신의 감정을 기록했습니다..");

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StateContainer(child: DailyPage())));
            },
            child: Text(
              "기록하기",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build input_page_step3');

    final height = MediaQuery.of(context).size.height;

//    SingleChildScrollView
    return Container(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          titleWidget(),
          toolBarWidget(),
          reasonTagList(),
          writeReasonTitle(),
          writeReasonField(),
          SizedBox(
            height: height * 0.1,
          ),
          recordButton(),
        ],
      ),
    ));
  }
}
