import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/edit_tag_dialog.dart';
import 'package:flutterapp/components/input/step3/reason_tag_widget.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_has_emotion.dart';
import 'package:flutterapp/models/record_has_tag.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/emotion/emotion_service.dart';
import 'package:flutterapp/services/record/record_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class InputPageStep3 extends StatefulWidget {
  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {
  TagProvider tagProvider;
  TextEditingController _textEditingController = TextEditingController();

  Future<List<Tag>> createEditTagDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Provider(create: (_) => TagProvider(), child: EditTagDialog());
        });
  }

  @override
  Widget build(BuildContext context) {
    print('build input_page_step3');

    tagProvider = Provider.of<TagProvider>(context);
    final container = StateContainer.of(context);

//    this._tags =  Provider.of<List<Tag>>(context);

    Widget titleWidget = Container(
        padding: EdgeInsets.only(top: 110, left: 70, right: 70),
        child: Center(
            child: Text(
          "그렇게 느끼는 이유는...",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        )));
    Widget toolBarWidget = Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "이유태그",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () async {
                createEditTagDialog(context).then((value) {
                  this.tagProvider.getTags();
                });
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "태그편집",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ));
    Widget reasonTagList = Container(
      height: 120,
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: StreamProvider<List<Tag>>.value(
          initialData: [Tag(name: 'asdf', id: 'asdf')],
          value: tagProvider.tags,
          child: ReasonTagWidget()),
    );
    Widget writeReasonTitle = Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "이유적기",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ));
    Widget writeReasonField = Container(
        padding: EdgeInsets.only(top: 13, left: 20, right: 20),
        child: TextField(
          controller: _textEditingController,
          cursorColor: CommonService.hexToColor("#34b7eb"),
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "더 자세히 떠올려보자"),
        ));
    Widget recordButton = Container(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
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

              container.tags.forEach((tag) async {
                RecordHasTag recordHasTagParam = RecordHasTag(
                    recordId: recordParam.id,
                    tagId: tag.id,
                    createdAt: DateTime.now().toString());
                print("recordHasTagParam -> ${recordHasTagParam.toJson()}");
                await TagService().insertRecordHasTag(recordHasTagParam);
              });

              container.emotions.forEach((emotion) async {
                RecordHasEmotion recordHasEmotion = RecordHasEmotion(
                  recordId: recordParam.id,
                  emotionId: emotion.id,
                    createdAt: DateTime.now().toString());
                await EmotionService().insertRecordHasEmotion(recordHasEmotion);
              });

              CommonService.showToast("당신의 감정을 기록했습니다..");

              Navigator.pop(context);
            },
            child: Text(
              "기록하기",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          )),
    );
//    SingleChildScrollView
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            titleWidget,
            toolBarWidget,
            reasonTagList,
            writeReasonTitle,
            writeReasonField,
            recordButton,
          ],
        ),
      )),
    );
  }
}
