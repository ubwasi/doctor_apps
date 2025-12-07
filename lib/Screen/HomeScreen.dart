import 'package:doctor_apps/Theme/Theme.dart';
import 'package:doctor_apps/Widget/TextEdtingField.dart';
import 'package:flutter/material.dart';

import '../Widget/AppointmentDoctor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final List<String> categories = ['All', 'Cardiology', 'Medicine', 'General'];
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Maria Waston",
      "sub": "Heart Surgeon, London, England",
      "rating": 4.9,
      "image":
          "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500",
    },
    {
      "name": "Dr. John Smith",
      "sub": "Cardiologist, New York",
      "rating": 4.6,
      "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500",
    },
    {
      "name": "Dr. Emma Brown",
      "sub": "Medicine Specialist, Canada",
      "rating": 4.9,
      "image":
          "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=500",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightTheme.backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 9, right: 9),
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            "https://i.imgur.com/BoN9kdC.png",
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Welcome Back",
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: LightTheme.subTitleColors,
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: ChoiceChip(
                              label: Text(
                                categories[index],
                                style: TextStyle(
                                  color: _selectedCategory == index
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                              selected: _selectedCategory == index,
                              selectedColor: LightTheme.primaryColors,
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    ListView.builder(
                      itemCount: doctors.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final doc = doctors[index];
                        return AppointmentDoctor(
                          name: doc["name"],
                          subtitle: doc["sub"],
                          rating: doc["rating"],
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
