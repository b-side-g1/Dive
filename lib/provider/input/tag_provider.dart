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
  final _tagsController = StreamController<List<Tag>>.broadcast();

  StreamSink<List<Tag>> get _inTags => _tagsController.sink;

  Stream<List<Tag>> get tags => _tagsController.stream;

  final _addTagController = StreamController<Tag>.broadcast();
  StreamSink<Tag> get inAddTag => _addTagController.sink;

  TagProvider() {
    print('construct!');
    getTags();

    _addTagController.stream.listen(_handleAddTag);
  }

  Future<List<Tag>> getAllTags() async {
    TagService tagService = new TagService();
    return tagService.selectAllTags();
  }

  Future<Tag> addTag(Tag tagParam) async {
    TagService tagService = new TagService();
    return tagService.insertTag(tagParam);
  }

  void getTags() async {
    List<Tag> tags = await TagService().selectAllTags();
    _inTags.add(tags);
  }

  void _handleAddTag(Tag tagParam) async {
    await TagService().insertTag(tagParam);

    getTags();
  }


  void dispose() {
    this._tagsController.close();
    this._addTagController.close();
  }

}