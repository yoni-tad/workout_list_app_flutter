import 'package:flutter/material.dart';
import 'package:workout_list/screens/home_screen.dart';
import 'package:workout_list/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: AppColors.text),
          bodyMedium: TextStyle(color: AppColors.text),
        )
      ),
      home: HomeScreen(),
    );
  }
}

