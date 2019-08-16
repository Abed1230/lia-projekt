import 'package:cloud_firestore/cloud_firestore.dart';

class LoveLanguage {
  final String id;
  final String title;
  final String description;

  LoveLanguage({this.id, this.title, this.description});

  factory LoveLanguage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return LoveLanguage(
        id: doc.documentID,
        title: data['title'] ?? '',
        description: data['description'] ?? '');
  }
}
