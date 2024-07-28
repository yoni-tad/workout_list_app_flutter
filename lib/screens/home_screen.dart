import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:workout_list/utils/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _workouts = [];
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final todayDayOfWeek = DateFormat('EEEE').format(_currentDate);
      final allWorkouts = await DBHelper().getWorkouts();

      final filteredWorkouts = allWorkouts.where((workout) {
        final workoutDate = DateFormat('EEEE')
            .format(DateFormat('EEE, MMM d, yyyy').parse(workout['date']));
        return workoutDate == todayDayOfWeek;
      }).toList();

      if (filteredWorkouts.isEmpty) {
        print('No workouts found for today!');
      }

      setState(() {
        _workouts = filteredWorkouts;
      });
    } catch (e) {
      print('Error loading workouts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF846AFF),
                        Color(0xFF755EE8),
                        Colors.purpleAccent,
                        Colors.amber,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi, Yoni',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Today workouts',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMEd().format(_currentDate),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _workouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/01.json',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No workout found!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _workouts.map((workout) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: workout['image'] != null
                                    ? FileImage(File(workout['image']))
                                    : const AssetImage('assets/images/150.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
