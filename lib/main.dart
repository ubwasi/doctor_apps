import 'package:doctor_apps/Auth/Screen/LogInScreen.dart';
import 'package:doctor_apps/Auth/Screen/RegScreen.dart';
import 'package:doctor_apps/Screen/BottomNavbar.dart';
import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = await _getInitialRoute();
  final appLifecycleObserver = AppLifecycleObserver();
  WidgetsBinding.instance.addObserver(appLifecycleObserver);
  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> _getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
    return '/reg';
  }

  final lastUsedTimestamp = prefs.getInt('last_used_timestamp') ?? 0;
  final now = DateTime.now().millisecondsSinceEpoch;
  final sevenDaysInMillis = 7 * 24 * 60 * 60 * 1000;

  if (now - lastUsedTimestamp > sevenDaysInMillis) {
    return '/login';
  }

  return '/home';
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      initialRoute: initialRoute,
      routes: {
        '/reg': (context) => const RegScreen(),
        '/login': (context) => const LogInScreen(),
        '/home': (context) => const BottomNavBar(),
      },
    );
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_used_timestamp', DateTime.now().millisecondsSinceEpoch);
    }
  }
}
