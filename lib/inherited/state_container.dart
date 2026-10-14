import 'package:flutter/material.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/models/tag_model.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final int? score;
  final List<Emotion>? emotions;
  final List<Tag>? tags;
  final String? description;
  final Record? record;
  final String? selectedTime;

  const StateContainer({
    super.key,
    required this.child,
    this.score,
    this.emotions,
    this.tags,
    this.description,
    this.record,
    this.selectedTime,
  });

  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>())!
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  int score = 50;
  List<Emotion> emotions = [];
  List<Tag> tags = [];
  String description = "";
  Record? record;
  String selectedTime = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      score = widget.score ?? 50;
      emotions = widget.emotions ?? [];
      tags = widget.tags ?? [];
      description = widget.description ?? "";
      record = widget.record;
      selectedTime = DateTime.now().toString();
    });
  }

  void updateScore(int score) {
    setState(() {
      this.score = score;
    });
  }

  void updateTime(String time) {
    setState(() {
      selectedTime = time;
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
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
