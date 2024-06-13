import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habituo/models/habit-firebase.dart';
import 'package:habituo/services/habit_service.dart';

class AddHabitPage extends StatefulWidget {
  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Color _color = Colors.blue.shade400;
  String _completedDays = '';
  bool _notify = false;
  Duration _time = const Duration(hours: 0, minutes: 0);

  final HabitService _habitService = HabitService();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      _formKey.currentState?.validate();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: _time,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                _time = newDuration;
              });
            },
          ),
        );
      },
    );
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      Habit habit = Habit(
        name: _nameController.text,
        description: _descriptionController.text,
        color: _color,
        completedDays: _completedDays,
        notify: _notify,
        time: _time,
      );

      // await _habitService.addHabit(habit);
      // if (mounted) {
      //   Navigator.pop(context);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: const Text('Add new habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              const SizedBox(height: 30),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  for (var color in [
                    Colors.blue.shade400,
                    Colors.indigo.shade400,
                    Colors.teal.shade300,
                    Colors.green.shade400,
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
              const SizedBox(height: 30),
              const Text(
                'Goal',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Time of action',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 16),
                          Text(
                            "${_time.inHours.toString().padLeft(2, '0')}:${(_time.inMinutes % 60).toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Reminder',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Push notification',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Switch(
                    value: _notify,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                      setState(() {
                        // _notify = value;
                      });
                    },
                  ),
                ],
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
                      backgroundColor:
                          Colors.grey[600], // Sets background color
                      minimumSize: const Size(120, 50),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black), // Sets text color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue[300], // Sets background color
                      minimumSize: const Size(120, 50),
                    ),
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
