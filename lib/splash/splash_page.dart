import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AssetImage assetsImage = AssetImage('lib/src/image/splash@3x.png');
    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height;

    debugPrint("넓이 $deviceWidth height $deviceHeight");

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: assetsImage,
              fit: BoxFit.cover
            )
          ),
        )
    );
  }
}