
import 'package:karlekstanken/models/completion_status.dart';

class CoupleData {
  CompletionStatus completionStatus;

  CoupleData({this.completionStatus});

  factory CoupleData.fromMap(Map data) {
    if (data == null) return null;

    return new CoupleData(completionStatus: CompletionStatus.fromMap(data['completionStatus']));
  }
}