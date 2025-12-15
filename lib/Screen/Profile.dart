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
    final user = _user['data']?['user'];
    final name = user?['name'] ?? "User";
    final email = user?['email'] ?? "user@example.com";
    final phone = user?['phone'] ?? "";
    final imageFromApi = user?['image'];
    final imageUrl = (imageFromApi != null && imageFromApi.isNotEmpty)
        ? imageFromApi
        : "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500";


    return Scaffold(
      body:
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top:70),
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

                ProfileMenu(
                  title: "Settings",
                  icon: Icons.settings,
                  onPress: () {},
                ),
                ProfileMenu(
                  title: "Billing Details",
                  icon: Icons.wallet,
                  onPress: () {},
                ),
                ProfileMenu(
                  title: "User Management",
                  icon: Icons.person_add,
                  onPress: () {},
                ),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenu(title: "Information", icon: Icons.info, onPress: () {}),
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
}
