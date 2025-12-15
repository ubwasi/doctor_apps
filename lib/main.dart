import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/Screen/RegScreen.dart';
import 'Auth/Screen/LogInScreen.dart';
import 'Screen/BottomNavbar.dart';
import 'Theme/Theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasRegistered = prefs.getBool('hasRegistered') ?? false;
  final authToken = prefs.getString('authToken');

  runApp(MyApp(hasRegistered: hasRegistered, authToken: authToken));
}

class MyApp extends StatelessWidget {
  final bool hasRegistered;
  final String? authToken;

  const MyApp({super.key, required this.hasRegistered, this.authToken});

  @override
  Widget build(BuildContext context) {
    Widget initialScreen;

    if (!hasRegistered) {
      initialScreen = const RegScreen();
    } else if (authToken == null) {
      initialScreen = const LogInScreen();
    } else {
      initialScreen = const BottomNavBar();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      home: initialScreen,
    );
  }
}
