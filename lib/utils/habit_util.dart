import 'package:flutter/material.dart';
import 'package:habituo/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays, focusDate) {
  return completedDays.any((date) => date == focusDate);
}

Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    if (habit.completedDays != null) {
      for (var date in habit.completedDays!) {
        final normalizedDate = DateTime(date.year, date.month, date.day);

        if (dataset.containsKey(normalizedDate)) {
          dataset[normalizedDate] = dataset[normalizedDate]! + 1;
        } else {
          dataset[normalizedDate] = 1;
        }
      }
    }
  }

  return dataset;
}

Color getLighterShade(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');
  final int red = color.red + ((255 - color.red) * amount).round();
  final int green = color.green + ((255 - color.green) * amount).round();
  final int blue = color.blue + ((255 - color.blue) * amount).round();
  return Color.fromARGB(color.alpha, red, green, blue);
}

Color getDarkerShade(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');
  final int red = (color.red * (1 - amount)).round();
  final int green = (color.green * (1 - amount)).round();
  final int blue = (color.blue * (1 - amount)).round();
  return Color.fromARGB(color.alpha, red, green, blue);
}

extension DateTimeFromTimeOfDay on DateTime {
  DateTime appliedFromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }
}
