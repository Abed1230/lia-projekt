import 'package:karlekstanken/models/progress.dart';

class CoupleData {
  Progress progress;

  CoupleData({this.progress});

  factory CoupleData.fromMap(Map data) {
    if (data == null) return null;

    return new CoupleData(progress: Progress.fromMap(data['progress']));
  }
}