import 'package:flutter/material.dart';
import 'package:flutterapp/models/tag_model.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final int score;
  final List emotions;

  StateContainer({
    @required this.child,
    this.score,
    this.emotions,
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
  int score;
  List emotions;
  List<Tag> tags;

  void updateScore(score) {
    setState(() {
      this.score = score;
    });
  }

  void updateEmotions(emotions) {
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
