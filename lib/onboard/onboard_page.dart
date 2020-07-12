import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_service.dart';
import 'package:flutterapp/provider/time_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutterapp/onboard/animate/animate_widget.dart';

class OnBoardPage extends StatelessWidget {
  gradientBackground() {
    return LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color.fromRGBO(61, 81, 152, 1), Color.fromRGBO(7, 36, 84, 1)]);
  }

  buildBackground() {
    return BoxDecoration(
      gradient: gradientBackground(),
    );
  }

  _topLightImage() {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset('lib/src/image/onboarding/2.0x/light@2x.png'),
    );
  }

  _bottomWaveImage() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset('lib/src/image/onboarding/2.0x/wave@2x.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          decoration: buildBackground(),
          child: Stack(
            children: <Widget>[
              _topLightImage(),
              _bottomWaveImage(),
              Provider(
                create: (context) => TimePickerProvider(),
                child: OnboardAnimate() ,
              )
            ],
          )),
    ));
  }
}
