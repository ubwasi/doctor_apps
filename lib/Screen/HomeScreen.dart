import 'package:doctor_apps/Theme/Theme.dart';
import 'package:doctor_apps/Widget/TextEdtingField.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/AppointmentDoctor.dart';
import '../Widget/CategoryItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  List<Map<String, dynamic>> doctors = [];
  late Map _user;

  final List<Map<String, dynamic>> categories = [
    {
      "icon": Icons.verified_rounded,
      "label": "All",
      "iconColor": const Color(0xFF6CE9A6),
      "backgroundColor": const Color(0xFFE8FDF0),
    },
    {
      "icon": Icons.monitor_heart_rounded,
      "label": "Cardiology",
      "iconColor": const Color(0xFFFF6B6B),
      "backgroundColor": const Color(0xFFFFF0F0),
    },
    {
      "icon": Icons.medication_rounded,
      "label": "Medicine",
      "iconColor": const Color(0xFFC77DFF),
      "backgroundColor": const Color(0xFFF8F0FF),
    },
    {
      "icon": Icons.healing_rounded,
      "label": "General",
      "iconColor": const Color(0xFFFF8787),
      "backgroundColor": const Color(0xFFFFF2F2),
    },
  ];

  loadUserData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var userData = await sharedPrefs.getString('user');
    var user = jsonDecode(userData ?? '{}') as Map;
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    loadUserData();
  }

  Future<void> _loadDoctors() async {
    final String data = await rootBundle.loadString(
      'Services/API Services/doctorsList.json',
    );
    final List<dynamic> jsonData = json.decode(data);
    if (mounted) {
      setState(() {
        doctors = jsonData.cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedDoctors;
    final selectedCategoryLabel = categories[_selectedCategoryIndex]['label'];

    if (_selectedCategoryIndex == 0) {
      displayedDoctors = doctors;
    } else {
      displayedDoctors = doctors
          .where(
            (doctor) =>
                (doctor['category'] as String?)?.toLowerCase() ==
                selectedCategoryLabel.toLowerCase(),
          )
          .toList();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 9, right: 9),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LightTheme.linnerColors,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu_rounded,
                          color: LightTheme.backgroundColors,
                          size: 35,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _user['image'] ?? "https://i.imgur.com/BoN9kdC.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Welcome Back ${_user['name']}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),

                    const Text(
                      "Let's find your\ntop doctor!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextEditingField(
                        title: "",
                        hintText: "Search health issue...",
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: LightTheme.titleColors,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(categories.length, (index) {
                          final category = categories[index];
                          return CategoryItem(
                            icon: category["icon"],
                            label: category["label"],
                            iconColor: category["iconColor"],
                            backgroundColor: category["backgroundColor"],
                            isSelected: _selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      key: ValueKey(selectedCategoryLabel),
                      itemCount: displayedDoctors.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final doc = displayedDoctors[index];
                        return AppointmentDoctor(
                          name: doc["name"],
                          subtitle: doc["sub"],
                          rating: doc["rating"].toDouble(),
                          image: doc["image"],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
