import 'package:flutter/material.dart';
import 'package:habituo/utils/habit_util.dart';

class HabitCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String time;
  final int streak;
  final Color backgroundColor;
  // final Color markedColor;
  final bool isCompleted;

  const HabitCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.streak,
    required this.backgroundColor,
    // required this.markedColor,
    this.isCompleted = false,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isCompleted;
  }

  String _streakText(int streak) {
    return streak == 1 ? "$streak day streak" : "$streak days streak";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isChecked ? Colors.green : widget.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isChecked
                        ? Colors.white
                        : getLighterShade(widget.backgroundColor, 0.2),
                    border: isChecked
                        ? null
                        : Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
                  ),
                  child: isChecked
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: widget.backgroundColor,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
