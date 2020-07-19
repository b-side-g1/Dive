import 'package:flutter/material.dart';
import 'package:flutterapp/components/input/step3/reason_tag_widget.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/pages/input/step3/edit_tag_list.dart';
import 'package:flutterapp/provider/tag_provider.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class InputPageStep3 extends StatefulWidget {
  @override
  _InputPageStep3State createState() => _InputPageStep3State();
}

class _InputPageStep3State extends State<InputPageStep3> {

  Future<String> createEditTagDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Stack(children: <Widget>[
              Center(
                child: Text(
                  "태그편집",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
              ),
            ]),
            content:
            MultiProvider(
              providers: [
                FutureProvider(builder: (_) => TagProvider().getAllTags())
              ],
              child: EditTagList(),
            ),
            actions: <Widget>[
              SizedBox(
                width: double.maxFinite,
                child: ButtonTheme(
                    height: 44,
                    child: FlatButton(
                      color: CommonService.hexToColor("#63c7ff"),
                      textColor: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "저장",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 110, left: 70, right: 70),
                child: Center(
                    child: Text(
                  "그렇게 느끼는 이유는...",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ))),
            Container(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "이유태그",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        createEditTagDialog(context).then((value) {
                          debugPrint(
                              "[input_page_step3.dart] createEditTagDialog value ->  ${value}");
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 75),
                child: ReasonTagWidget()),
            Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "이유적기",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 13, left: 20, right: 20),
                child: TextFormField(
                  cursorColor: CommonService.hexToColor("#34b7eb"),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "더 자세히 떠올려보자"),
                )),
            Container(
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
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
                    onPressed: () {},
                    child: Text(
                      "기록하기",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
