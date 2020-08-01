import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';

class RecordProvider {
  Record record;

  // ignore: close_sinks
  final _recordController = StreamController<Record>.broadcast();

  StreamSink<Record> get inRecord => _recordController.sink;

  Stream<Record> get recordStream => _recordController.stream;

  // ignore: close_sinks
  final _addRecordController = StreamController<Record>.broadcast();
  StreamSink<Record> get inAddRecord => _addRecordController.sink;

  RecordProvider() {
    print('RecordProvider construct!');
    _addRecordController.stream.listen(_handleAddRecord);
  }

  void _handleAddRecord(Record recordParam) async {
  }

  void dispose() {
    this._recordController.close();
    this._addRecordController.close();
  }

}