import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/love_language.dart';
import 'package:karlekstanken/models/query.dart' as my;
import 'package:karlekstanken/models/user.dart';

class DatabaseService {
  static const String CHAPTERS_FREE = 'chapters_free';
  static const String CHAPTERS_PAID = 'chapters_paid';
  static const String TASKS = 'tasks';
  static const String USERS = 'users';
  static const String LOVE_LANGUAGE_TEST_QUERIES = 'loveLanguageTestQueries';
  static const String LOVE_LANGUAGES = 'loveLanguages';

  static const String POSITION = 'position';

  final Firestore _db = Firestore.instance;

  // ---------------------- GET OPERATIONS ------------------------

  Future<List<Chapter>> getChapters(bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .orderBy(POSITION)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    return docs.map((doc) => Chapter.fromFirestore(doc)).toList();
  }

  Future<List<Task>> getTasks(String docId, bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .document(docId)
        .collection(TASKS)
        .orderBy(POSITION)
        .getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    return docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  Future<List<Chapter>> getChaptersWithTasks(bool licensed) async {
    QuerySnapshot query = await _db
        .collection(licensed ? CHAPTERS_PAID : CHAPTERS_FREE)
        .orderBy(POSITION)
        .getDocuments();

    List<DocumentSnapshot> docs = query.documents;
    List<Future<Chapter>> mappedList = docs.map((doc) async {
      Chapter chapter = Chapter.fromFirestore(doc);
      chapter.tasks = await getTasks(chapter.id, licensed);
      return chapter;
    }).toList();
    Future<List<Chapter>> futureList = Future.wait(mappedList);
    List<Chapter> chapters = await futureList;
    return chapters;
  }

  Future<List<my.Query>> getTestQueries() async {
    QuerySnapshot snapshot = await _db
        .collection(LOVE_LANGUAGE_TEST_QUERIES)
        .orderBy('position')
        .getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;
    List<my.Query> queries =
        docs.map((doc) => my.Query.fromMap(doc.data)).toList();
    return queries;
  }

  Future<List<LoveLanguage>> getLoveLanguages(List<String> ids) async {
    List<DocumentSnapshot> docs = [];
    for (String id in ids) {
      docs.add(await _db.collection(LOVE_LANGUAGES).document(id).get());
    }
    List<LoveLanguage> langs =
        docs.map((doc) => LoveLanguage.fromFirestore(doc)).toList();
    langs.sort((a, b) => a.id.compareTo(b.id));
    return langs;
  }

  Future<LoveLanguage> getLoveLanguage(String id) async {
    DocumentSnapshot doc =
        await _db.collection(LOVE_LANGUAGES).document(id).get();
    return LoveLanguage.fromFirestore(doc);
  }

  Stream<User> streamUser(String uid) {
    if (uid == null) return Stream<User>.empty();
    return _db
        .collection(USERS)
        .document(uid)
        .snapshots()
        .map((snap) => User.fromFirestore(snap));
  }

  Stream<CoupleData> streamCoupleData(DocumentReference ref) {
    if (ref == null) return Stream<CoupleData>.empty();

    return ref.snapshots().map((snap) => CoupleData.fromMap(snap.data));
  }

  // ---------------------- UPDATE OPERATIONS ------------------------

  void updateChapterCompletionStatus(
      {DocumentReference coupleDataRef,
      String chapterId,
      bool isChapterCompleted,
      Map<String, bool> tasks}) {
    Map<String, bool> data = {
      'completionStatus.chapters.$chapterId': isChapterCompleted
    };

    tasks.forEach((id, completed) {
      data['completionStatus.tasks.$id'] = completed;
    });

    coupleDataRef.updateData(data);
  }

  void saveLoveLangauge(
      {String loveLanguage, String uid, DocumentReference coupleDataRef}) {
    _db
        .collection(USERS)
        .document(uid)
        .updateData({'loveLanguage': loveLanguage});
    coupleDataRef.updateData({'loveLanguages.$uid': loveLanguage});
  }

  // ---------------------- CREATE OPERATIONS ------------------------

  void createUserDocument(
      {@required String userId,
      @required String email,
      @required String name}) {
    _db
        .collection(USERS)
        .document(userId)
        .setData({'email': email, 'name': name, 'licensed': false});
  }

  // ---------------------- DELETE OPERATIONS ------------------------
}
