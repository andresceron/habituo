// import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habituo/models/habit.dart';
import 'package:habituo/pages/add_habit_page.dart';
import 'package:habituo/services/auth_service.dart';
import 'package:habituo/services/habit_service.dart';
import 'package:provider/provider.dart';
import '/components/my_habit_tile.dart';
import '/components/my_heat_map.dart';
import '../components/timeline_widget.dart';
import '/utils/habit_util.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final HabitService _habitService = HabitService();
  DateTime _focusDate =
      DateTime.now().appliedFromTimeOfDay(const TimeOfDay(hour: 0, minute: 0));

  @override
  void initState() {
    super.initState();
  }

  void createNewHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitPage()),
    );
  }

  void checkHabitOnoff(Habit habit, bool? value) {
    if (value != null) {
      _habitService.updateHabitCompletion(habit, value, _focusDate);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitPage(habit: habit)),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              _habitService.deleteHabit(habit.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser!.email!.toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Hello $userEmail!"),
        titleTextStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        // elevation: 0,
        backgroundColor: Colors.black87,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          TextButton(
            onPressed: () {
              createNewHabit();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
            ),
            child: const Row(
              children: [
                Text('Add new habit '),
                Icon(Icons.add),
              ],
            ),
          ),
        ],
      ),
      body: _getBodyContent(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            label: 'Habits',
            icon: Icon(Icons.app_registration_rounded),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            label: 'Progress',
            icon: Icon(Icons.bar_chart_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }

  Widget _getBodyContent(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            _timeLine(),
            Expanded(
              child: _buildHabitList(),
            ),
          ],
        );
      case 1:
        return ListView(
          children: [
            _timeLine(),
            _buildHeatMap(),
          ],
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 60),
              elevation: 0,
            ),
            onPressed: () async {
              await AuthService().logout(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      default:
        return Container(); // Empty container as a default
    }
  }

  Widget _timeLine() {
    return TimelineWidget(
      focusDate: _focusDate,
      onDateChange: (selectedDate) {
        setState(() {
          _focusDate = selectedDate;
        });
      },
    );
  }

  Widget _buildHeatMap() {
    // final habitDatabase = context.watch<HabitDatabase>();
    // List<Habit> currentHabits = habitDatabase.currentHabits;

    // return FutureBuilder<DateTime?>(
    //   future: habitDatabase.getFirstLaunchDate(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return MyHeatMap(
    //         startDate: snapshot.data!,
    //         datasets: prepHeatMapDataset(currentHabits),
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );

    return Container();
  }

  Widget _buildHabitList() {
    return StreamBuilder<List<Habit>>(
      stream: _habitService.getHabitsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Habit> habits = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              bool isCompletedToday = isHabitCompletedToday(
                habit.completedDays ?? [],
                _focusDate,
              );

              return MyHabitTile(
                text: habit.name,
                backgroundColor: habit.color,
                scheduled: habit.scheduled,
                scheduledTime: habit.scheduledTime,
                durationTime: habit.durationTime,
                duration: habit.duration,
                isCompleted: isCompletedToday,
                streakCount: 2,
                notify: habit.notify,
                onChanged: (value) => checkHabitOnoff(habit, value),
                editHabit: (context) => editHabitBox(habit),
                deleteHabit: (context) => deleteHabitBox(habit),
              );
            },
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.track_changes,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Habits Yet!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Get started by adding a new habit to track.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  minimumSize: const Size(150, 50),
                ),
                onPressed: () => createNewHabit(),
                child: const Text(
                  'Add New Habit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
