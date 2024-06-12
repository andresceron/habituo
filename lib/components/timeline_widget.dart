import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TimelineWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateChange;
  final DateTime focusDate;

  const TimelineWidget({
    super.key,
    required this.onDateChange,
    required this.focusDate,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();

  List<DateTime> disabledDates = [];

  @override
  void initState() {
    super.initState();
    generateDisabledDates();
    // _controller.setFocusDate(widget.focusDate);
  }

  void generateDisabledDates() {
    DateTime startDate = DateTime.now().add(const Duration(days: 1));
    DateTime endDate = DateTime(2025, 1, 1);
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      disabledDates.add(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyInfiniteDateTimeLine(
      timeLineProps: const EasyTimeLineProps(
        hPadding: 0.0,
        vPadding: 5.0,
        separatorPadding: 10.0,
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
      ),
      controller: _controller,
      firstDate: DateTime(2024, 6, 1),
      focusDate: widget.focusDate,
      disabledDates: disabledDates,
      lastDate: DateTime(2024, 12, 31),
      activeColor: Colors.blueGrey.shade400,
      locale: 'en_US',
      showTimelineHeader: false,
      dayProps: const EasyDayProps(
        borderColor: Colors.transparent,
        width: 64.0,
        height: 80.0,
      ),
      onDateChange: (selectedDate) {
        widget.onDateChange(selectedDate);
      },
    );
  }
}
