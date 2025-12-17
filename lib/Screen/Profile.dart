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
  Map<String, dynamic> _user = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('data');

    if (userData != null) {
      _user = jsonDecode(userData);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _user;

    final name = user['name'] ?? 'User';
    final email = user['email'] ?? 'user@example.com';
    final phone = user['phone'] ?? '';
    final imageFromApi = user['image'];

    final imageUrl = (imageFromApi != null && imageFromApi.toString().isNotEmpty)
        ? imageFromApi
        : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500';

    final healthInfo = user['health_info'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image
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
                      errorBuilder: (_, __, ___) => Image.network(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
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
                      color: LightTheme.primaryColors,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            Text(email, style: Theme.of(context).textTheme.bodyMedium),
            if (phone.isNotEmpty)
              Text(phone, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 20),

            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightTheme.primaryColors,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),

            _buildInfoSection(
              title: 'Personal Information',
              icon: Icons.person,
              info: {
                'Date of Birth': user['date_of_birth'],
                'Age': user['age'],
                'Gender': user['gender_label'],
                'Blood Group': user['blood_group'],
              },
            ),

            _buildInfoSection(
              title: 'Contact Information',
              icon: Icons.contact_mail,
              info: {
                'Address': user['address'],
                'City': user['city'],
                'District': user['district'],
                'Postal Code': user['postal_code'],
                'Emergency Contact': user['emergency_contact'],
              },
            ),

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
                },
              ),

            _buildInfoSection(
              title: 'Account Information',
              icon: Icons.security,
              info: {
                'Email Verified': user['email_verified']?.toString(),
                'Member Since': user['created_at'],
              },
            ),

            const Divider(),
            ProfileMenu(
              title: 'Logout',
              icon: Icons.logout,
              textColor: Colors.red,
              endIcon: false,
              onPress: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Map<String, dynamic> info,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: info.entries.map((e) {
        return ListTile(
          title: Text(e.key),
          trailing: Text(e.value?.toString() ?? 'N/A'),
        );
      }).toList(),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    }
  }
}
