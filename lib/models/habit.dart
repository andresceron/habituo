import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  String? id;
  String? uid;
  String name;
  Color color = Colors.blue.shade400;
  List<DateTime>? completedDays = [];
  bool duration = false;
  bool notify = false;
  bool scheduled;
  DateTime? scheduledTime;
  Duration? durationTime;
  Timestamp? createdAt;
  Timestamp? updatedAt = Timestamp.now();

  Habit({
    this.id,
    required this.uid,
    required this.name,
    required this.color,
    required this.notify,
    required this.scheduled,
    required this.duration,
    required this.durationTime,
    this.scheduledTime,
    this.completedDays,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Habit object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'color': color.value,
      'completed_days':
          completedDays?.map((date) => Timestamp.fromDate(date)).toList(),
      'notify': notify,
      'scheduled': scheduled,
      'scheduled_time': scheduledTime?.millisecondsSinceEpoch,
      'duration': duration,
      'duration_time': durationTime?.inMilliseconds,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create a Habit object from a Map object
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      uid: map['uid'],
      name: map['name'],
      color: Color(map['color']),
      completedDays: map['completed_days'] != null
          ? (map['completed_days'] as List<dynamic>)
              .map((timestamp) => (timestamp as Timestamp).toDate())
              .toList()
          : [],
      notify: map['notify'],
      scheduled: map['scheduled'],
      scheduledTime: map['scheduled_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['scheduled_time'])
          : null,
      duration: map['duration'],
      durationTime: map['duration_time'] != null
          ? Duration(milliseconds: map['duration_time'])
          : null,
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
      color: Color(data['color']),
      completedDays: (data['completed_days'] as List<dynamic>)
          .map((timestamp) => (timestamp as Timestamp).toDate())
          .toList(),
      notify: data['notify'],
      scheduled: data['scheduled'],
      scheduledTime: data['scheduled_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['scheduled_time'])
          : null,
      duration: data['duration'] ?? false,
      durationTime: data['duration_time'] != null
          ? Duration(milliseconds: data['duration_time'])
          : null,
      createdAt: data['created_at'] ?? Timestamp.now(),
      updatedAt: data['updated_at'] ?? Timestamp.now(),
    );
  }
}
