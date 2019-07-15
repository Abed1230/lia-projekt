import 'package:cloud_firestore/cloud_firestore.dart';

class Chapter {
  final String id;
  final String title;
  final String previewText;
  final String mainText;
  final String audioUrl;
  final List<String> videoUrls;
  final bool isPreview;

  Chapter(
      {this.id,
      this.title,
      this.previewText,
      this.mainText,
      this.audioUrl,
      this.videoUrls,
      this.isPreview});

  factory Chapter.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
  
    return Chapter(
        id: doc.documentID,
        title: data['title'] ?? 'Title',
        previewText: data['previewText'] ?? 'description',
        mainText: data['mainText'] ?? '',
        audioUrl: data['audioUrl'],
        videoUrls: data['videoUrls']?.cast<String>()?.toList(),
        isPreview: data['isPreview'] ?? true);
  }
}

class Task {
  final String id;
  final String title;
  final String mainText;
  final String previewText;
  final String audiourl;
  final String pdfUrl;

  Task(
      {this.id,
      this.title,
      this.mainText,
      this.previewText,
      this.audiourl,
      this.pdfUrl});

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Task(
        id: doc.documentID,
        title: data['title'] ?? 'Title',
        previewText: data['previewText'] ?? 'description',
        mainText: data['mainText'] ?? '',
        audiourl: data['audioUrl'],
        pdfUrl: data['pdfUrl']);
  }
}
