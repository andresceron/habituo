import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habituo/models/habit.dart';
import 'package:habituo/services/auth_service.dart';
import 'package:habituo/services/habit_service.dart';
import 'package:habituo/utils/habit_util.dart';

class AddHabitPage extends StatefulWidget {
  final Habit? habit;

  AddHabitPage({this.habit});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Color _color = Colors.blue.shade400;
  bool _notify = false;
  bool _duration = false;
  bool _scheduled = false;
  Duration _durationTime = const Duration(hours: 0, minutes: 30);
  DateTime _scheduledTime = DateTime.now();

  final HabitService _habitService = HabitService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _color = widget.habit!.color;
      _notify = widget.habit!.notify;
      _duration = widget.habit!.duration;
      _scheduled = widget.habit!.scheduled;
      _durationTime = widget.habit!.durationTime ?? Duration.zero;
      if (widget.habit!.scheduledTime != null) {
        _scheduledTime = widget.habit!.scheduledTime!;
      }
    }

    _nameController.addListener(() {
      _formKey.currentState?.validate();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return CupertinoDatePicker(
          initialDateTime: _scheduledTime,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
          onDateTimeChanged: (DateTime newTime) {
            setState(() => _scheduledTime = newTime);
          },
        );
      },
      scrollControlDisabledMaxHeightRatio: 0.3,
    );
  }

  Future<Duration?> _selectDuration(BuildContext context) async {
    return await showModalBottomSheet<Duration>(
      context: context,
      builder: (BuildContext context) => CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: _durationTime,
        onTimerDurationChanged: (Duration newDuration) {
          setState(() => _durationTime = newDuration);
        },
      ),
      scrollControlDisabledMaxHeightRatio: 0.3,
    );
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      Habit habit = Habit(
        id: widget.habit?.id,
        uid: _authService.currentUser.uid,
        name: _nameController.text,
        color: _color,
        notify: _notify,
        scheduled: _scheduled,
        scheduledTime: _scheduledTime,
        duration: _duration,
        durationTime: _durationTime,
        completedDays: widget.habit?.completedDays ?? [],
        createdAt: widget.habit?.createdAt,
      );

      if (widget.habit != null) {
        await _habitService.updateHabit(habit);
      } else {
        await _habitService.addHabit(habit);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: Text(widget.habit != null ? 'Edit Habit' : 'Add New Habit'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Title*',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (_nameController.text.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  for (var color in [
                    Colors.blue.shade400,
                    Colors.indigo.shade400,
                    Colors.teal.shade300,
                    Colors.orange.shade400,
                    Colors.red.shade400,
                    Colors.purple.shade400,
                    Colors.pink.shade300,
                    Colors.amber.shade300,
                    Colors.brown.shade400,
                  ])
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _color = color;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _color == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Divider(
              thickness: 0.1,
              height: 0.0,
            ),

            // Duration
            ListTile(
              textColor:
                  WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.red;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.green;
                }
                return Colors.black;
              }),
              title: const Text('Enable Duration'),
              trailing: Switch(
                value: _duration,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    _duration = value;
                  });
                },
              ),
            ),
            if (_duration)
              ListTile(
                  title: const Text('Duration Time'),
                  trailing: Text(
                    formatDuration(_durationTime),
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () async {
                    Duration? pickedDuration = await _selectDuration(context);
                    if (pickedDuration != null) {
                      setState(() {
                        _durationTime = pickedDuration;
                      });
                    }
                  }),

            const Divider(
              thickness: 0.1,
              height: 0.0,
            ),

            // Scheduled
            ListTile(
              textColor:
                  WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.red;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.green;
                }
                return Colors.black;
              }),
              title: const Text('Enable Scheduling'),
              trailing: Switch(
                value: _scheduled,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    _scheduled = value;
                  });
                },
              ),
            ),

            if (_scheduled)
              ListTile(
                onTap: () => _selectTime(context),
                title: const Text('Schedule Time'),
                subtitle: const Text(
                  'At what time you plan to do it',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                trailing: Text(
                  formatDateTime(_scheduledTime),
                  style: const TextStyle(fontSize: 18),
                ),
              ),

            const Divider(
              thickness: 0.1,
              height: 0.0,
            ),

            ListTile(
              textColor:
                  WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.red;
                }
                if (states.contains(WidgetState.selected)) {
                  return Colors.green;
                }
                return Colors.black;
              }),
              // leading: const Icon(Icons.person),
              title: const Text('Reminder'),
              subtitle: const Text(
                'Enable/disable push notification',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: Switch(
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                activeColor: Colors.green,
                value: _notify,
                onChanged: (bool value) {
                  setState(() => _notify = value);
                },
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    minimumSize: const Size(150, 50),
                  ),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
