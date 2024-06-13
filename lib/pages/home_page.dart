// import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habituo/pages/add_habit_page.dart';
import 'package:habituo/services/auth_service.dart';
import 'package:provider/provider.dart';
import '/components/my_habit_tile.dart';
import '/components/my_heat_map.dart';
import '../components/timeline_widget.dart';
import '/database/habit_database.dart';
import '/models/habit.dart';
import '/utils/habit_util.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  DateTime _focusDate = DateTime.now();

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  void createNewHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitPage()),
    );
  }

  void checkHabitOnoff(bool? value, Habit habit) {
    if (value != null) {
      context
          .read<HabitDatabase>()
          .updateHabitCompletion(habit.id, value, _focusDate);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
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
              context.read<HabitDatabase>().deleteHabit(habit.id);

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
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
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday =
            isHabitCompletedToday(habit.completedDays, _focusDate);
        return MyHabitTile(
          text: habit.name,
          backgroundColor: Colors.blueGrey.shade300,
          isCompleted: isCompletedToday,
          streakCount: 2,
          onChanged: (value) => checkHabitOnoff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
