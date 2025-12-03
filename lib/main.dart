import 'package:doctor_apps/Screen/AppointmentScreen.dart';
import 'package:doctor_apps/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: AppointmentScreen(),
    );
  }
}

