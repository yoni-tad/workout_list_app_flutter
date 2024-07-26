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
        padding: EdgeInsets.all(8.0),
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: workout['image'] != null
                          ? FileImage(File(workout['image']))
                          : AssetImage('assets/images/150.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   crossAxisSpacing: 10.0,
      //   mainAxisSpacing: 10.0,
      //   shrinkWrap: true,
      //   padding: const EdgeInsets.all(8.0),
      //   children: List.generate(
      //     _workouts.length,
      //     (index) {
      //       final workout = _workouts[index];
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Container(
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             color: Colors.grey[200],
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Container(
      //                 height: MediaQuery.of(context).size.height / 4,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.vertical(
      //                     top: Radius.circular(10),
      //                   ),
      //                   image: DecorationImage(
      //                     image: workout['image'] != null
      //                         ? FileImage(File(workout['image']))
      //                         : AssetImage('assets/images/150.png')
      //                             as ImageProvider,
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     FittedBox(
      //                       fit: BoxFit.scaleDown,
      //                       child: Text(
      //                         workout['name'],
      //                         style: TextStyle(fontWeight: FontWeight.bold),
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),

      // body: ListView.builder(
      //   itemCount: _workouts.length,
      //   itemBuilder: (context, index) {
      //     final workout = _workouts[index];
      //     return Column(
      //       children: [
      //         Container(
      //           child: Image(image: workout['image'] != null ? AssetImage('assets/images/150.png') : FileImage(File(workout['image']))),
      //         ),
      //       ],
      //     );
      //     // return ListTile(
      //     //   leading: workout['image'] != null
      //     //       ? CircleAvatar(
      //     //           backgroundImage: FileImage(File(workout['image'])),
      //     //         )
      //     //       : CircleAvatar(
      //     //           child: Icon(Icons.image),
      //     //         ),
      //     //   title: Text(workout['name']),
      //     //   subtitle: Text(workout['date']),
      //     // );
      //   },
      // ),
    );
  }
}
