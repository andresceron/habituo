import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:intl/intl.dart';

class AddHabitPage extends StatefulWidget {
  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _habitNameController =
      TextEditingController(text: 'Your new habit');
  final TextEditingController _reminderTextController = TextEditingController();
  Duration _selectedDuration = const Duration(hours: 0, minutes: 0);
  Color _selectedColor = Colors.red; // Default color
  // int _frequency = 3; // Default frequency
  bool _reminderEnabled = false;

  Future<void> _selectTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: _selectedDuration,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                _selectedDuration = newDuration;
              });
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _selectedColor,
        title: Text(_habitNameController.text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitNameController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
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
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: _selectedColor == color
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // const Text(
            //   'Goal',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     const Text(
            //       'Times a week',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //     const Spacer(),
            //     IconButton(
            //       icon: const Icon(Icons.remove),
            //       onPressed: () {
            //         setState(() {
            //           if (_frequency > 1) _frequency--;
            //         });
            //       },
            //     ),
            //     Text(
            //       '$_frequency',
            //       style: const TextStyle(fontSize: 20),
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.add),
            //       onPressed: () {
            //         setState(() {
            //           if (_frequency < 7) _frequency++;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
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
                  value: _reminderEnabled,
                  // inactiveThumbColor: Colors.red,
                  // inactiveTrackColor: Colors.red,
                  // activeColor: Colors.green,
                  onChanged: (bool value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
              ],
            ),
            if (_reminderEnabled)
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(8),
                            // ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 16),
                                Text(
                                  "${_selectedDuration.inHours.toString().padLeft(2, '0')}:${(_selectedDuration.inMinutes % 60).toString().padLeft(2, '0')}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: _reminderTextController,
                          decoration: const InputDecoration(
                            labelText: 'Reminder text',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                // borderSide: BorderSide(color: Colors.red),
                                ),
                          ),
                        ),
                      ),
                    ],
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
                    backgroundColor: Colors.grey[300], // Sets background color
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black), // Sets text color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your save habit logic here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Sets background color
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
