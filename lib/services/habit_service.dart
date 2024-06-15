import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habituo/models/habit.dart';

class HabitService {
  final CollectionReference habits =
      FirebaseFirestore.instance.collection('habits');

  Future<void> addHabit(Habit habit) {
    habit.createdAt = Timestamp.now();
    habit.updatedAt = Timestamp.now();
    return habits.add(habit.toMap());
  }

  Future<void> updateHabit(Habit habit) {
    return habits.doc(habit.id).update(habit.toMap());
  }

  Future<void> deleteHabit(String id) {
    return habits.doc(id).delete();
  }

  Future<void> updateHabitCompletion(Habit habit, isCompleted, focusDate) {
    habit.completedDays ??= [];

    if (isCompleted && !habit.completedDays!.contains(DateTime.now())) {
      habit.completedDays!.add(focusDate);
    } else {
      habit.completedDays!.removeWhere((date) => date == focusDate);
    }
    return habits.doc(habit.id).update(habit.toMap());
  }

  // Future<List<Habit>> getHabits() async {
  //   QuerySnapshot snapshot = await habits.get();
  //   return snapshot.docs.map((doc) => Habit.fromDocumentSnapshot(doc)).toList();
  // }

  Stream<List<Habit>> getHabitsStream() {
    return habits
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return query.docs.map((doc) => Habit.fromDocumentSnapshot(doc)).toList();
    });
  }
}
