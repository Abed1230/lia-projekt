import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class MyProgressIndicator extends StatelessWidget {

  MyProgressIndicator(this._totalTasks, this._completedTasks);

  final int _totalTasks; 
  final int _completedTasks;

  double _calculateValue() {
    return (_completedTasks/_totalTasks);
  }

  Path _buildHeartPath() {
    return new Path()
     ..moveTo(44, 12)
      ..cubicTo(44, 9.6, 40, 0, 24, 0)
      ..cubicTo(0, 0, 0, 30, 0, 30)
      ..cubicTo(0, 48, 16, 61.6, 44, 80)
      ..cubicTo(72, 61.6, 88, 48, 88, 30)
      ..cubicTo(88, 30, 88, 0, 64, 0)
      ..cubicTo(52, 0, 44, 9.6, 44, 12)
      ..close();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidCustomProgressIndicator(
        value: _calculateValue(),
        direction: Axis.vertical,
        backgroundColor: Colors.red.withAlpha(150),
        valueColor: AlwaysStoppedAnimation(Colors.red),
        shapePath: _buildHeartPath(),
        center: Text(
          "${(_calculateValue() * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            color: Colors.red[800],
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
}