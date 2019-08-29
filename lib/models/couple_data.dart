import 'package:karlekstanken/models/completion_status.dart';

class CoupleData {
  final CompletionStatus completionStatus;
  final Map<String, String> loveLanguages;

  CoupleData({this.completionStatus, this.loveLanguages});

  factory CoupleData.fromMap(Map data) {
    if (data == null) return null;

    return new CoupleData(
        completionStatus: CompletionStatus.fromMap(data['completionStatus']),
        loveLanguages: data['loveLanguages']?.cast<String, String>());
  }
}
