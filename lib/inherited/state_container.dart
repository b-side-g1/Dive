import 'package:flutter/material.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/models/tag_model.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final int score;
  final List<Emotion> emotions;
  final List<Tag> tags;
  final String description;
  final Record record;
  final String selectedTime;

  StateContainer({
    @required this.child,
    this.score,
    this.emotions,
    this.tags,
    this.description,
    this.record,
    this.selectedTime
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  int score = 50;
  List<Emotion> emotions = [];
  List<Tag> tags = [];
  String description;
  Record record;
  String selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      score = widget.score ?? 50;
      emotions = widget.emotions ?? [];
      tags = widget.tags ?? [];
      description = widget.description ?? "";
      record = widget.record ?? null;
      selectedTime = DateTime.now().toString();
    });
  }
  void updateScore(score) {
    setState(() {
      this.score = score;
    });
  }
  void updateTime(time) {
    setState(() {
      this.selectedTime = time;
    });
  }
  void updateEmotions(List<Emotion> emotions) {
    setState(() {
      this.emotions = emotions;
    });
  }

  void updateTags(List<Tag> tags) {
    setState(() {
      this.tags = tags;
    });
  }

  void printHello() {
    setState(() {
      print("Hello");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
