import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Theme/Theme.dart';
import '../Widget/TextEdtingField.dart';
import '../Widget/AppointmentDoctor.dart';
import '../Widget/CategoryItem.dart';
import '../domain/requests/doctor_requests.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool>? onThemeChanged;
  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  int _selectedCategoryIndex = 0;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic> _user = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _loadUserData();

    final brightness = WidgetsBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('data');
    if (userData != null) {
      setState(() {
        _user = jsonDecode(userData);
      });
    }
  }

  Future<void> _loadDoctors() async {
    final result = await getDoctors();

    if (!mounted) return;

    if (result['success'] == true) {
      final apiDoctors = List<Map<String, dynamic>>.from(result['data']);

      final Set<String> specialtySet = {};
      final List<Map<String, dynamic>> specialtyCategories = [
        {
          "label": "All",
          "icon": Icons.verified_rounded,
          "iconColor": const Color(0xFF6CE9A6),
          "backgroundColor": const Color(0xFFE8FDF0),
        }
      ];

      for (var doctor in apiDoctors) {
        final specialty = doctor['specialty'];
        if (specialty != null && !specialtySet.contains(specialty['name'])) {
          specialtySet.add(specialty['name']);
          specialtyCategories.add({
            "label": specialty['name'],
            "icon": _getSpecialtyIcon(specialty['name']),
            "iconColor": _getSpecialtyColor(specialty['name']),
            "backgroundColor": _getSpecialtyBgColor(specialty['name']),
          });
        }
      }

      setState(() {
        doctors = apiDoctors;
        categories = specialtyCategories;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData _getSpecialtyIcon(String specialtyName) {
    switch (specialtyName.toLowerCase()) {
      case 'cardiology':
        return Icons.monitor_heart_rounded;
      case 'gynecology':
        return Icons.female_rounded;
      case 'pediatrics':
        return Icons.child_care_rounded;
      case 'neurology':
        return Icons.psychology_rounded;
      case 'psychiatry':
        return Icons.emoji_people_rounded;
      case 'dermatology':
        return Icons.healing_rounded;
      case 'orthopedics':
        return Icons.fitness_center_rounded;
      case 'ophthalmology':
        return Icons.remove_red_eye_rounded;
      case 'dentistry':
        return Icons.icecream;
      case 'ent':
        return Icons.hearing_rounded;
      case 'medicine':
        return Icons.medication_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }

  Color _getSpecialtyColor(String specialtyName) {
    switch (specialtyName.toLowerCase()) {
      case 'cardiology':
        return const Color(0xFFFF6B6B);
      case 'gynecology':
        return const Color(0xFFC77DFF);
      case 'pediatrics':
        return const Color(0xFF6CE9A6);
      case 'neurology':
        return const Color(0xFFFFA500);
      case 'psychiatry':
        return const Color(0xFF00CED1);
      case 'dermatology':
        return const Color(0xFFFF8787);
      case 'orthopedics':
        return const Color(0xFF8A2BE2);
      case 'ophthalmology':
        return const Color(0xFF1E90FF);
      case 'dentistry':
        return const Color(0xFFDA70D6);
      case 'ent':
        return const Color(0xFF20B2AA);
      case 'medicine':
        return const Color(0xFFFF6347);
      default:
        return Colors.grey;
    }
  }

  Color _getSpecialtyBgColor(String specialtyName) {
    return _getSpecialtyColor(specialtyName).withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories.isEmpty
        ? "All"
        : categories[_selectedCategoryIndex]['label'];

    final List<Map<String, dynamic>> displayedDoctors =
    selectedCategory == "All"
        ? doctors
        : doctors.where((doctor) {
      final specialty = doctor['specialty']?['name'];
      return specialty != null &&
          specialty.toLowerCase() == selectedCategory.toLowerCase();
    }).toList();

    return Scaffold(
      drawer: _drawer(),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              _categories(),
              _doctorList(displayedDoctors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LightTheme.linnerColors,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    _user['image'] ??
                        'https://cdn2.suno.ai/12e0a3d6-9154-4b5e-9b44-75e01826b8a1_4964085d.jpeg',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _user['name'] ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _user['email'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                });
                if (widget.onThemeChanged != null) {
                  widget.onThemeChanged!(val);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              _openPrivacyPolicy();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Your privacy is important. We do not share personal data with third parties...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _header() {
    final userImage = _user['image'] ??
        'https://cdn2.suno.ai/12e0a3d6-9154-4b5e-9b44-75e01826b8a1_4964085d.jpeg';
    final userName = _user['name'] ?? 'User';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LightTheme.linnerColors,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: LightTheme.backgroundColors,
                      size: 35,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  userImage,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Welcome Back, $userName",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Find Your Doctor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const TextEditingField(
              title: "",
              hintText: "Search doctor...",
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: categories.isEmpty
          ? const SizedBox()
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CategoryItem(
                icon: categories[index]['icon'],
                label: categories[index]['label'],
                iconColor: categories[index]['iconColor'],
                backgroundColor: categories[index]['backgroundColor'],
                isSelected: _selectedCategoryIndex == index,
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _doctorList(List<Map<String, dynamic>> doctors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: doctors.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return AppointmentDoctor(
            doctor: doc,
          );
        },
      ),
    );
  }
}
