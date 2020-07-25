import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';

class TagProvider {
  Tag tag;

  // ignore: close_sinks
  StreamController<Tag> _tagController = StreamController();
  Stream<Tag> get tagStream => _tagController.stream;

  Future<List<Tag>> getAllTags() async {
    TagService tagService = new TagService();
    return tagService.selectAllTags();
  }

  Future<Tag> addTag(Tag tagParam) async {
    TagService tagService = new TagService();
    return tagService.insertTag(tagParam);
  }

  void dispose() {
    this._tagController.close();
  }

}