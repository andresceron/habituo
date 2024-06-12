import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completedDays = [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completedDays':
          completedDays.map((date) => date.toIso8601String()).toList(),
    };
  }

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, completedDays: $completedDays}';
  }
}
