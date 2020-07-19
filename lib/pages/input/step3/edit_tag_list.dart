import 'package:flutter/material.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/provider/tag_provider.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:provider/provider.dart';

class EditTagList extends StatefulWidget {
  @override
  _EditTagListState createState() => _EditTagListState();
}

class _EditTagListState extends State<EditTagList> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Tag> _tags;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(BuildContext context, Tag item, Animation<double> animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: SizedBox(
          height: 50.0,
          child: Card(
            child: Center(
              child: Text(item.name, style: textStyle),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    this._tags = Provider.of<List<Tag>>(context);

    return Container(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: this._tags.length,
        itemBuilder: (context,index,animation) => _buildItem(context,_tags[index],animation),
      ),
    );
  }
}
