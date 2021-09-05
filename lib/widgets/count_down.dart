import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountDown extends AnimatedWidget {
  CountDown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    var timerText =
        ' ${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      '${timerText}',
      style: GoogleFonts.mcLaren(
        fontSize: 40,
        color: Colors.blue[500],
      ),
    );
  }
}

class CountDownMinute extends AnimatedWidget {
  CountDownMinute({Key key, this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(minutes: animation.value);
    var timerText = '${clockTimer.inMinutes.remainder(60).toString()} : ';

    return Text(
      '${timerText}',
      style: GoogleFonts.mcLaren(
        fontSize: 40,
        color: Colors.blue[500],
      ),
    );
  }
}
/*
class CountDown extends AnimatedWidget {
  CountDown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    Duration clockTimer =
    Duration(seconds: animation.value);
    var timerText = '${clockTimer.inMinutes.remainder(60).toString()} : '
        ' ${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      '${timerText}',
      style: TextStyle(fontSize: 40, color: Theme.of(context).primaryColor),
    );
  }
}*/
