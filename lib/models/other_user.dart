class OtherUser {
  final String uid;
  final String name;
  final String email;

  OtherUser({this.uid, this.name, this.email});

  factory OtherUser.fromMap(Map data) {
    return OtherUser(uid: data['uid'] ?? '', name: data['name'] ?? '', email: data['email'] ?? '');
  }
}