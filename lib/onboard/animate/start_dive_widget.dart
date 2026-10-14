import 'package:flutter/material.dart';
import 'package:Dive/controller/diary_tab_controller.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/provider/time_picker_provider.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:provider/provider.dart';

class StartDiveWidget extends StatelessWidget {
  const StartDiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    PickerTime pickerTime = Provider.of<PickerTime>(context);
    TimePickerProvider timePickerProvider =
        Provider.of<TimePickerProvider>(context);
    return SizedBox(
      width: 316,
      height: 60,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          backgroundColor: CommonService.hexToColor("#63c7ff"),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(8.0),
        ),
        onPressed: () async {
          timePickerProvider.updateEndAt(pickerTime);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => DiaryTabController()));
        },
        child: Text(
          "시작하기",
          style: TextStyle(fontSize: width * 0.06, fontFamily: "NotoSans"),
        ),
      ),
    );
  }
}
