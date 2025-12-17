import 'dart:convert';

import 'package:doctor_apps/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Theme/Theme.dart';
import '../Widget/AppointmentDoctor.dart';
import '../Widget/CategoryItem.dart';

class TopDoctors extends StatefulWidget {
  const TopDoctors({super.key});

  @override
  State<TopDoctors> createState() => _TopDoctorsState();
}

class _TopDoctorsState extends State<TopDoctors> {
  int _selectedCategoryIndex = 0;
  List<Map<String, dynamic>> doctors = [];

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

  @override
  void initState() {
    super.initState();
    _loadDoctors();
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
    List<Map<String, dynamic>> filteredDoctors;
    final selectedCategoryLabel = categories[_selectedCategoryIndex]['label'];

    if (_selectedCategoryIndex == 0) {
      filteredDoctors = doctors;
    } else {
      filteredDoctors = doctors
          .where((doctor) =>
      (doctor['category'] as String?)
          ?.toLowerCase() ==
          selectedCategoryLabel.toLowerCase())
          .toList();
    }

    final displayedDoctors = List<Map<String, dynamic>>.from(filteredDoctors)
      ..sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Top Doctors",
          style: TextStyle(
            color: LightTheme.titleColors,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
            const SizedBox(height: 20),
            Row(
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                key: ValueKey(selectedCategoryLabel),
                itemCount: displayedDoctors.length,
                itemBuilder: (context, index) {
                  final doc = displayedDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppointmentDoctor(
                      doctor: doc,

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
