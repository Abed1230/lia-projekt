import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String loveLanguage;
  final Map partner;
  final bool licensed;
  final Map partnerRequestFrom;
  final Map partnerRequestTo;
  final DocumentReference coupleDataRef;

  User(
      {this.uid,
      this.name,
      this.email,
      this.loveLanguage,
      this.partner,
      this.licensed,
      this.partnerRequestFrom,
      this.partnerRequestTo,
      this.coupleDataRef});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        uid: doc.documentID,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        loveLanguage: data['loveLanguage'],
        partner: data['partner'],
        licensed: data['licensed'],
        partnerRequestFrom: data['partnerRequestFrom'],
        partnerRequestTo: data['partnerRequestTo'],
        coupleDataRef: data['coupleDataRef']);
  }
}
