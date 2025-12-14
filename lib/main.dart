import 'package:doctor_apps/Screen/BottomNavbar.dart';
import 'package:doctor_apps/Screen/HomeScreen.dart';
import 'package:doctor_apps/Screen/TopDoctors.dart';
import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';

import 'Auth/Screen/LogInScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      home: LogInScreen(),
    );
  }
}
