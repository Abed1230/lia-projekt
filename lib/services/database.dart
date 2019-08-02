import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/user.dart';

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
    chapters.sort((a, b) => a.title.compareTo(b.title));
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
    tasks.sort((a, b) => a.title.compareTo(b.title));
    return tasks;
  }

  Future<List<Chapter>> getChaptersWithTasks(bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .getDocuments();
        
    List<DocumentSnapshot> docs = query.documents;
    List<Future<Chapter>> mappedList =
        docs.map((doc) async {
          Chapter chapter = Chapter.fromFirestore(doc);
          chapter.tasks = await getTasks(chapter.id, licensed);
          return chapter;
          }).toList();
    Future<List<Chapter>> futureList = Future.wait(mappedList);
    List<Chapter> chapters = await futureList;
    chapters.sort((a, b) => a.title.compareTo(b.title));
    return chapters;
  }

  Stream<User> streamUser(String uid) {
    if (uid == null) return Stream<User>.empty();
    return _db
        .collection(USERS)
        .document(uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }

  Stream<CoupleData> streamCoupleData(DocumentReference ref) {
    if (ref == null) return Stream<CoupleData>.empty();

    return ref.snapshots().map((snap) => CoupleData.fromMap(snap.data));
  }

  void updateChapterCompletionStatus(
      DocumentReference coupleDataRef,
      String chapterId,
      bool isChapterCompleted,
      String taskId,
      bool isTaskCompleted) {
    coupleDataRef.updateData({
      'completionStatus.chapters.$chapterId': isChapterCompleted,
      'completionStatus.tasks.$taskId': isTaskCompleted
    });
  }
}
