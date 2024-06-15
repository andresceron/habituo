import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  String? id;
  String uid;
  String name;
  String? description = '';
  Color color = Colors.blue.shade400;
  List<DateTime> completedDays = [];
  bool notify = false;
  Duration? time = Duration(hours: 0, minutes: 0);
  Timestamp? createdAt;
  Timestamp? updatedAt = Timestamp.now();

  Habit({
    this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.color,
    required this.completedDays,
    required this.notify,
    required this.time,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Habit object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'color': color.value,
      'completed_days':
          completedDays.map((date) => Timestamp.fromDate(date)).toList(),
      'notify': notify,
      'time': time?.inMilliseconds,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create a Habit object from a Map object
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      uid: map['uid'],
      name: map['name'],
      description: map['description'],
      color: Color(map['color']),
      completedDays: map['completed_days'] != null
          ? (map['completed_days'] as List<dynamic>)
              .map((timestamp) => (timestamp as Timestamp).toDate())
              .toList()
          : [],
      notify: map['notify'],
      time: map['time'] != null ? Duration(milliseconds: map['time']) : null,
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  // Create a Habit object from a DocumentSnapshot
  factory Habit.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Habit(
      id: doc.id,
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      color: Color(data['color']),
      completedDays: (data['completed_days'] as List<dynamic>)
          .map((timestamp) => (timestamp as Timestamp).toDate())
          .toList(),
      notify: data['notify'],
      time: data['time'] != null ? Duration(milliseconds: data['time']) : null,
      createdAt: data['created_at'] ?? Timestamp.now(),
      updatedAt: data['updated_at'] ?? Timestamp.now(),
    );
  }
}
