import 'package:doctor_apps/Auth/Screen/LogInScreen.dart';
import 'package:doctor_apps/Auth/Screen/RegScreen.dart';
import 'package:doctor_apps/Screen/BottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter AppRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    var path = state.uri.toString();
    if (path == '/profile') {
      var sharedPref = await SharedPreferences.getInstance();
      var token = await sharedPref.getString('token');
      if (token == null) return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'Home',
      pageBuilder: (context, state) =>
          MaterialPage(child: BottomNavBar(currentIndex: 0)),
    ),
    GoRoute(
      path: '/profile',
      name: 'Profile',
      pageBuilder: (context, state) =>
          MaterialPage(child: BottomNavBar(currentIndex: 2)),
    ),
    GoRoute(
      path: '/top-doctors',
      name: 'Top Doctors',
      pageBuilder: (context, state) =>
          MaterialPage(child: BottomNavBar(currentIndex: 1)),
    ),
    GoRoute(
      path: '/login',
      name: 'Login',
      pageBuilder: (context, state) => MaterialPage(child: LogInScreen()),
    ),
    GoRoute(
      path: '/register',
      name: 'Register',
      pageBuilder: (context, state) => MaterialPage(child: RegScreen()),
    ),
  ],
);
