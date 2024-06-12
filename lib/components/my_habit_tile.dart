import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habituo/utils/habit_util.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final bool isCompleted;
  final int streakCount;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.isCompleted,
    required this.streakCount,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  _MyHabitTileState createState() => _MyHabitTileState();
}

class _MyHabitTileState extends State<MyHabitTile> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isCompleted;
  }

  @override
  void didUpdateWidget(covariant MyHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted) {
      isChecked = widget.isCompleted;
    }
  }

  String _streakText(int streakCount) {
    return streakCount == 1
        ? "$streakCount day streak"
        : "$streakCount days streak";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.editHabit,
              backgroundColor: Colors.grey.shade200,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: widget.deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (widget.onChanged != null) {
              setState(() {
                isChecked = !isChecked;
                widget.onChanged!(isChecked);
              });
            }
          },
          child: Card(
            color: isChecked ? Colors.green : widget.backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                          widget.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Reminder @ 20:00',
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _streakText(widget.streakCount),
                          style: const TextStyle(
                            fontSize: 16,
                            // color: Colors.white70,
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
                              : getLighterShade(widget.backgroundColor, 0.3),
                          border: isChecked
                              ? null
                              : Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                        ),
                        child: isChecked
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.green,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
