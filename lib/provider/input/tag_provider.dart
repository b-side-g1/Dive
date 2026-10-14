import 'dart:async';
import 'package:Dive/models/tag_model.dart';
import 'package:Dive/services/tag/tag_service.dart';

class TagProvider {
  Tag? tag;

  // ignore: close_sinks
  final _tagsController = StreamController<List<Tag>>.broadcast();
  StreamSink<List<Tag>> get inTags => _tagsController.sink;
  Stream<List<Tag>> get tags => _tagsController.stream;

  // ignore: close_sinks
  final _addTagController = StreamController<Tag>.broadcast();
  StreamSink<Tag> get inAddTag => _addTagController.sink;

  // ignore: close_sinks
  final _deleteTagController = StreamController<Tag>.broadcast();
  StreamSink<Tag> get inDeleteTag => _deleteTagController.sink;

  // ignore: close_sinks
  final _testController = StreamController<List<Tag>>.broadcast();
  Stream<List<Tag>> get tests => _testController.stream;
  StreamSink<List<Tag>> get inTest => _testController.sink;

  TagProvider() {
    getTags();

    _addTagController.stream.listen(_handleAddTag);
    _deleteTagController.stream.listen(_handleDeleteTag);
  }

  Future<List<Tag>> getAllTags() async {
    TagService tagService = TagService();
    return tagService.selectAllTags();
  }

  void getTags() async {
    List<Tag> tags = await TagService().selectAllTags();
    inTags.add(tags);
  }

  void _handleAddTag(Tag tagParam) async {
    await TagService().insertTag(tagParam);
    getTags();
  }

  void _handleDeleteTag(Tag tagParam) async {
    await TagService().deleteTag(tagParam);
    getTags();
  }

  void handleLocalTags(List<Tag> tags) async {
    inTags.add(tags);
  }

  void dispose() {
    _tagsController.close();
    _addTagController.close();
    _testController.close();
    _deleteTagController.close();
  }
}
