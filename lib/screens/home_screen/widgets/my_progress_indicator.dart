import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class MyProgressIndicator extends StatelessWidget {
  MyProgressIndicator(this._totalTasks, this._completedTasks);

  final int _totalTasks;
  final int _completedTasks;

  double _calculateValue() {
    if (_completedTasks == 0 && _totalTasks == 0) return 0;
    if (_completedTasks == 1 && _totalTasks == 0) return 0;

    double value = (_completedTasks / _totalTasks);
    return value > 1.0 ? 1.0 : value;
  }

  Path _buildHeartPath() {
    return new Path()
      ..moveTo(42, 15.522499999999999)
      ..cubicTo(
          35.0385, -3.3740000000000014, 0, -0.5670000000000028, 0, 28.0105)
      ..cubicTo(0, 42.2485, 10.71, 61.194, 42, 80.5)
      ..cubicTo(73.28999999999999, 61.194, 84, 42.2485, 84, 28.0105)
      ..cubicTo(84, -0.40250000000000075, 49, -3.4860000000000015, 42, 15.5225)
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
