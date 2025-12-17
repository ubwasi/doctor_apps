import 'package:doctor_apps/providers/app_router.dart';
import 'package:flutter/material.dart';
import 'Theme/Theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: LightTheme.theme,
      darkTheme: LightTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter,
    );
  }
}
