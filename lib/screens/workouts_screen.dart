import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_list/utils/colors.dart';
import 'package:workout_list/utils/db_helper.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workouts = await DBHelper().getWorkouts();
      if (workouts.isEmpty) {
        print('No workouts found!');
      }
      setState(() {
        _workouts = workouts;
      });
    } catch (e) {
      print('Error loading workouts: $e');
    }
  }

  Future<void> _deleteWorkout(int id) async {
    try {
      await DBHelper().deleteWorkout(id);
      _loadWorkouts();
    } catch (e) {
      print('Error deleting workout: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 150,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Color(0xFF846AFF),
                //     Color(0xFF755EE8),
                //     Colors.purpleAccent,
                //     Colors.amber,
                //   ],
                // ),
                image: DecorationImage(
                  image: workout['image'] != null
                      ? FileImage(File(workout['image']))
                      : const AssetImage('assets/images/150.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        workout['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
