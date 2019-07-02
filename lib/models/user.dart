class User {
  final String uid;
  final String name;
  final String email;
  final Map partner;
  final bool licensed;
  final Map partnerRequestFrom;
  final Map partnerRequestTo;

  User(
      {this.uid,
      this.name,
      this.email,
      this.partner,
      this.licensed,
      this.partnerRequestFrom,
      this.partnerRequestTo});

  factory User.fromMap(Map data) {
    return User(
        uid: data['uid'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        partner: data['partner'],
        licensed: data['licensed'],
        partnerRequestFrom: data['partnerRequestFrom'],
        partnerRequestTo: data['partnerRequestTo']);
  }
}
