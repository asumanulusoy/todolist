class User {
  String uid;
  String email;
  String name;
  DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  // Map'ten User nesnesi oluşturma
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  // User nesnesini Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
