import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/user.dart';

// Todo use provider to provide this
class DatabaseService {
  static const String CHAPTERS_UNAUTHENTICATED = 'chapters_unauthenticated';
  static const String CHAPTERS = 'chapters';
  static const String TASKS = 'tasks';
  static const String USERS = 'users';
  final Firestore _db = Firestore.instance;

  Future<List<Chapter>> getChaptersUnauthenticated() async {
    QuerySnapshot query =
        await _db.collection(CHAPTERS_UNAUTHENTICATED).getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Chapter> chapters =
        docs.map((doc) => Chapter.fromFirestore(doc)).toList();
    chapters.sort((a, b) => a.id.compareTo(b.id));
    return chapters;
  }

  Future<List<Chapter>> getChapters() async {
    QuerySnapshot query = await _db.collection(CHAPTERS).getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Chapter> chapters =
        docs.map((doc) => Chapter.fromFirestore(doc)).toList();
    chapters.sort((a, b) => a.id.compareTo(b.id));
    return chapters;
  }

  /* Future<Chapter> getChapter(String id) async {
    DocumentSnapshot doc = await _db.collection(CHAPTERS).document(id).get();
    return Chapter.fromFirestore(doc);
  } */

  Future<List<Task>> getTasksUnauthenticated(String docId) async {
    QuerySnapshot query = await _db
        .collection(CHAPTERS_UNAUTHENTICATED)
        .document(docId)
        .collection(TASKS)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Task> tasks = docs.map((doc) => Task.fromFirestore(doc)).toList();
    tasks.sort((a, b) => a.id.compareTo(b.id));
    return tasks;
  }

  Future<List<Task>> getTasks(String docId) async {
    QuerySnapshot query = await _db
        .collection(CHAPTERS)
        .document(docId)
        .collection(TASKS)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    List<Task> tasks = docs.map((doc) => Task.fromFirestore(doc)).toList();
    tasks.sort((a, b) => a.id.compareTo(b.id));
    return tasks;
  }

  Stream<User> streamUser(String id) {
    return _db
        .collection(USERS)
        .document(id)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }
}
