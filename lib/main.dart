import 'package:flutter/material.dart';
import 'package:workout_list/screens/splash_screen.dart';
import 'package:workout_list/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontFamily: 'Roboto', color: AppColors.text),
          bodyMedium: TextStyle(fontFamily: 'Roboto', color: AppColors.text),
          bodyLarge: TextStyle(fontFamily: 'Roboto', color: AppColors.text),
          headlineMedium: TextStyle(fontFamily: 'Roboto', color: AppColors.text, fontWeight: FontWeight.bold),
        )
      ),
      home: SplashScreen(),
    );
  }
}

