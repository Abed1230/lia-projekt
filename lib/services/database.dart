import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karlekstanken/models/chapter.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<List<Chapter>> getChapters() async {
    QuerySnapshot query = await _db.collection('chapters').getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    // Todo maybe sort by id ascending
    return docs.map((doc) => Chapter.fromFirestore(doc)).toList();
  }
}