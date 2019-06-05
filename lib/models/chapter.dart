import 'package:cloud_firestore/cloud_firestore.dart';

class Chapter {
  final String id;
  final String title;
  final String description;
  final String text;
  final String video;
  final bool isPaid;

  Chapter({this.id, this.title, this.description, this.text, this.video, this.isPaid});

  factory Chapter.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Chapter(
        id: doc.documentID,
        title: data['title'] ?? 'Title',
        description: data['description'] ?? 'description',
        text: data['text'] ?? 'text',
        video: data['video'] ?? '',
        isPaid: data['isPaid'] ?? true);
  }
  /*  String get title => _title;
  String get description => _description;
  String get text => _text;
  String get video => _video; */
}

// Todo update when updateing structure in database
class Task {
  final String id;
  final String title;
  final String description;
  final String video;

  Task({this.id, this.title, this.description, this.video});

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Task(
        id: doc.documentID,
        title: data['title'] ?? 'title',
        description: data['description'] ?? 'description',
        video: data['video'] ?? '');
  }
}
