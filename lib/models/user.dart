import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String email;
  String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert a User object into a Map object
  Map<String?, dynamic> toMap() {
    return {
      id: id,
      name: name,
      email: email,
      password: password,
    };
  }

  // Create a User object from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  // Create a User object from a DocumentSnapshot
  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
    );
  }
}
