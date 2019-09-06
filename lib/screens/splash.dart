import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => routeToAppropriatePage(context));
  }

  @override
  Widget build(BuildContext context) {
    final String logoName = 'assets/images/ic_one_man_walking.svg';
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF69C0FF), Color(0xFF087ED2)])),
      child: Center(child: SvgPicture.asset(logoName, height: 151, width: 176)),
    ));
  }

  void routeToAppropriatePage(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        "/map_preview", (Route<dynamic> route) => false);
  }
}
