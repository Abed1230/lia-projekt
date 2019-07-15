import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/user.dart';

// Todo use provider to provide this
class DatabaseService {
  static const String CHAPTERS_FREE = 'chapters_free';
  static const String CHAPTERS_PAID = 'chapters_paid';
  static const String TASKS = 'tasks';
  static const String USERS = 'users';
  final Firestore _db = Firestore.instance;

  Future<List<Chapter>> getChapters(bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Chapter> chapters =
        docs.map((doc) => Chapter.fromFirestore(doc)).toList();
    chapters.sort((a, b) => a.id.compareTo(b.id));
    return chapters;
  }

  Future<List<Task>> getTasks(String docId, bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .document(docId)
        .collection(TASKS)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Task> tasks = docs.map((doc) => Task.fromFirestore(doc)).toList();
    tasks.sort((a, b) => a.id.compareTo(b.id));
    return tasks;
  }

  Stream<User> streamUser(String uid) {
    return _db
        .collection(USERS)
        .document(uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }
}
