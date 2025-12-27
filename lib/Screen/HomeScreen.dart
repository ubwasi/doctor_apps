import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Theme/Theme.dart';
import '../Widget/TextEdtingField.dart';
import '../Widget/AppointmentDoctor.dart';
import '../domain/requests/doctor_requests.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _user = {};
  bool isLoading = true;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> categories = [];
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadDoctors();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      _user = jsonDecode(userData);
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadDoctors() async {
    final result = await getDoctors();

    if (result['success'] == true) {
      doctors = List<Map<String, dynamic>>.from(result['data']);

      categories = [
        {
          "label": "All",
          "icon": Icons.local_hospital,
          "iconColor": Colors.green,
          "backgroundColor": Colors.green.withOpacity(.2),
        }
      ];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userName = _user['name'] ?? 'User';
    final userEmail = _user['email'] ?? '';
    final userImage = _user['image'] ??
        'https://www.shutterstock.com/image-vector/male-doctor-smiling-selfconfidence-flat-600nw-2281709217.jpg';

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LightTheme.linnerColors,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(userImage)),
                  const SizedBox(height: 10),
                  Text(userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(userEmail,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(userName, userImage),
              _userInfoCard(),
              _doctorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String name, String image) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LightTheme.linnerColors,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(image, height: 60, width: 60),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("Welcome Back, $name",
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Find Your Doctor",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14)),
            child: const TextEditingField(
              title: '',
              hintText: 'Search doctor...',
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfoCard() {
    final health = _user['health_info'] ?? {};

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Phone", _user['phone']),
              _row("Blood Group", _user['blood_group']),
              _row("Gender", _user['gender_label']),
              _row("Height", health['height']),
              _row("Weight", health['weight']),
              _row("BMI", health['bmi']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value?.toString() ?? "N/A")),
        ],
      ),
    );
  }

  Widget _doctorList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: doctors.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return AppointmentDoctor(doctor: doctors[index]);
        },
      ),
    );
  }
}
