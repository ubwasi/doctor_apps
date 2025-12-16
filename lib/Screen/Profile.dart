import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Theme/Theme.dart';
import '../Widget/ProfileMenu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map _user = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var userData = sharedPrefs.getString('data');
    if (userData != null && mounted) {
      setState(() {
        _user = jsonDecode(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _user.containsKey('data') ? _user['data'] as Map<String, dynamic>? : null;
    final user = data != null && data.containsKey('user') ? data['user'] as Map<String, dynamic>? : null;
    
    final name = user?['name'] ?? "User";
    final email = user?['email'] ?? "user@example.com";
    final phone = user?['phone'] ?? "";
    final imageFromApi = user?['image'];
    final imageUrl = (imageFromApi != null && imageFromApi.isNotEmpty)
        ? imageFromApi
        : "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500";
    
    final healthInfo = user?['health_info'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body:
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Image(
                            image: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500"),
                             fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: LightTheme.primaryColors,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(name, style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (phone.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 20),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightTheme.primaryColors,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                
                // Personal Info
                _buildInfoSection(
                  title: 'Personal Information',
                  icon: Icons.person,
                  info: {
                    'Date of Birth': user?['date_of_birth'],
                    'Age': user?['age'],
                    'Gender': user?['gender_label'],
                    'Blood Group': user?['blood_group'],
                  }
                ),

                // Contact Info
                _buildInfoSection(
                  title: 'Contact Information',
                  icon: Icons.contact_mail,
                  info: {
                    'Address': user?['address'],
                    'City': user?['city'],
                    'District': user?['district'],
                    'Postal Code': user?['postal_code'],
                    'Emergency Contact': user?['emergency_contact'],
                  }
                ),

                // Health Info
                if (healthInfo != null)
                  _buildInfoSection(
                    title: 'Health Information',
                    icon: Icons.medical_services,
                    info: {
                      'Allergies': healthInfo['allergies'],
                      'Chronic Conditions': healthInfo['chronic_conditions'],
                      'Current Medications': healthInfo['current_medications'],
                      'Height': healthInfo['height'],
                      'Weight': healthInfo['weight'],
                      'BMI': healthInfo['bmi'],
                    }
                  ),
                
                // Account Info
                _buildInfoSection(
                  title: 'Account Information',
                  icon: Icons.security,
                  info: {
                    'Email Verified': user?['email_verified']?.toString(),
                    'Member Since': user?['created_at'],
                  }
                ),

                const Divider(),
                const SizedBox(height: 10),
                ProfileMenu(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {},
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildInfoSection({required String title, required IconData icon, required Map<String, dynamic> info}) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: info.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          trailing: Text(entry.value?.toString() ?? 'N/A', textAlign: TextAlign.right),
        );
      }).toList(),
    );
  }
}
