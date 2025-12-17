import 'package:flutter/material.dart';
import '../Theme/Theme.dart';
import '../Widget/AppointmentDoctor.dart';
import '../Widget/CategoryItem.dart';
import '../domain/requests/doctor_requests.dart';

class TopDoctors extends StatefulWidget {
  const TopDoctors({super.key});

  @override
  State<TopDoctors> createState() => _TopDoctorsState();
}

class _TopDoctorsState extends State<TopDoctors> {
  int _selectedCategoryIndex = 0;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
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
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(

                scrollDirection: Axis.horizontal,
                child: _categories(),
              ),
              _doctorList(displayedDoctors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: categories.isEmpty
          ? const SizedBox()
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          return CategoryItem(
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
          );
        }),
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
