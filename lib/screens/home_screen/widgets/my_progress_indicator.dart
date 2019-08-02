import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class MyProgressIndicator extends StatelessWidget {

  Path _buildHeartPath() {
    return new Path()
     ..moveTo(55 * 0.8, 15 * 0.8)
      ..cubicTo(55 * 0.8, 12 * 0.8, 50 * 0.8, 0, 30 * 0.8, 0)
      ..cubicTo(0, 0, 0, 37.5 * 0.8, 0, 37.5 * 0.8)
      ..cubicTo(0, 60 * 0.8, 20 * 0.8, 77 * 0.8, 55 * 0.8, 100 * 0.8)
      ..cubicTo(90 * 0.8, 77 * 0.8, 110 * 0.8, 60 * 0.8, 110 * 0.8, 37.5 * 0.8)
      ..cubicTo(110 * 0.8, 37.5 * 0.8, 110 * 0.8, 0, 80 * 0.8, 0)
      ..cubicTo(65 * 0.8, 0, 55 * 0.8, 12 * 0.8, 55 * 0.8, 15 * 0.8)
   /*  ..moveTo(55 * 0.8, 15 * 0.8)
      ..cubicTo(55 * 0.8, 12 * 0.8, 50 * 0.8, 0, 30 * 0.8, 0)
      ..cubicTo(0, 0, 0, 37.5 * 0.8, 0, 37.5 * 0.8)
      ..cubicTo(0, 55 * 0.8, 20 * 0.8, 77 * 0.8, 55 * 0.8, 95 * 0.8)
      ..cubicTo(90 * 0.8, 77 * 0.8, 110 * 0.8, 55 * 0.8, 110 * 0.8, 37.5 * 0.8)
      ..cubicTo(110 * 0.8, 37.5 * 0.8, 110 * 0.8, 0, 80 * 0.8, 0)
      ..cubicTo(65 * 0.8, 0, 55 * 0.8, 12 * 0.8, 55 * 0.8, 15 * 0.8) */
     /* ..moveTo(27.5, 7.5)
      ..cubicTo(27.5, 6, 25, 0, 15, 0)
      ..cubicTo(0, 0, 0, 18.75, 0, 18.75)
      ..cubicTo(0, 27.5, 10, 38.5, 27.5, 47.5)
      ..cubicTo(45, 38.5, 55, 27.5, 55, 18.75)
      ..cubicTo(55, 18.75, 55, 0, 40, 0)
      ..cubicTo(32.5, 0, 27.5, 6, 27.5, 7.5) */
     /*  ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15) */
      ..close();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidCustomProgressIndicator(
        value: 0.3,
        direction: Axis.vertical,
        backgroundColor: Colors.red.withAlpha(150),
        valueColor: AlwaysStoppedAnimation(Colors.red),
        shapePath: _buildHeartPath(),
        center: Text(
          "90%",
          style: TextStyle(
            color: Colors.red[800],
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
}