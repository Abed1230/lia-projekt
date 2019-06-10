class User {
  final String uid;
  final String name;
  final String email;

  User({this.uid, this.name, this.email});

  factory User.fromMap(Map data) {
    return User(uid: data['uid'] ?? '', name: data['name'] ?? '', email: data['email'] ?? '');
  }
}