import 'package:doctor_apps/Screen/AppointmentScreen.dart';
import 'package:doctor_apps/Screen/HomeScreen.dart';
import 'package:doctor_apps/Screen/Profile.dart';
import 'package:doctor_apps/Screen/TopDoctors.dart';
import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int currentIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    TopDoctors(),
    ProfileScreen()
  ];


  Future<bool> _onWillPop() async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
      return false;
    }
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          selectedItemColor:LightTheme.primaryColors,
          backgroundColor: LightTheme.backgroundColors,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
      
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ""
      
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ""
            ),
          ],
        ),
      ),
    );
  }
}
