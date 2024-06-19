import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habituo/utils/habit_util.dart';

class MyHabitTile extends StatefulWidget {
  final String text;
  final String? description;
  final DateTime? scheduledTime;
  final Color backgroundColor;
  final bool isCompleted;
  final int streakCount;
  final bool notify;
  final bool duration;
  final bool scheduled;
  final Duration? durationTime;
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
    required this.notify,
    required this.duration,
    required this.scheduled,
    this.durationTime,
    this.description,
    this.scheduledTime,
  });

  @override
  State<MyHabitTile> createState() => _MyHabitTileState();
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
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.editHabit,
              backgroundColor: Colors.grey.shade700,
              icon: Icons.settings,
            ),
            SlidableAction(
              onPressed: widget.deleteHabit,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          color: isChecked ? Colors.green : widget.backgroundColor,
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.durationTime != null && widget.duration
                      ? formatDuration(widget.durationTime!)
                      : 'Duration not set',
                  style: widget.durationTime == null && !widget.duration
                      ? const TextStyle(color: Colors.black54)
                      : null,
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.notify
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    size: 18,
                    color: widget.notify ? Colors.white : Colors.red,
                  )
                ],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isChecked && widget.scheduled)
                  Text(
                    formatDateTime(widget.scheduledTime!),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                if (!isChecked && !widget.scheduled)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getLighterShade(widget.backgroundColor, 0.3),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                if (isChecked)
                  Container(
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
              ],
            ),
            onTap: () => setState(() {
              if (widget.onChanged != null) {
                setState(() {
                  isChecked = !isChecked;
                  widget.onChanged!(isChecked);
                });
              }
            }),
            onLongPress: () => widget.deleteHabit?.call(context),
          ),
        ),
      ),
    );
  }
}
