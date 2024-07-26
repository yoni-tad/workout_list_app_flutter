import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return ListTile(
            leading: workout['image'] != null
                ? CircleAvatar(
                    backgroundImage: FileImage(File(workout['image'])),
                  )
                : CircleAvatar(
                    child: Icon(Icons.image),
                  ),
            title: Text(workout['name']),
            subtitle: Text(workout['date']),
          );
        },
      ),
    );
  }
}
