import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditingScreen extends StatefulWidget {
  const ProfileEditingScreen({super.key});

  @override
  State<ProfileEditingScreen> createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {

  Map<String, dynamic> _user = {};



  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Personal and Contact Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  // Health Info
  final _allergiesController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalCodeController.dispose();
    _emergencyContactController.dispose();
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _currentMedicationsController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData0() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var userString = sharedPrefs.getString('user');
    if (userString != null && mounted) {
      final user = jsonDecode(userString);
      setState(() {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone'] ?? '';
        _dobController.text = user['date_of_birth'] ?? '';
        _addressController.text = user['address'] ?? '';
        _cityController.text = user['city'] ?? '';
        _districtController.text = user['district'] ?? '';
        _postalCodeController.text = user['postal_code'] ?? '';
        _emergencyContactController.text = user['emergency_contact'] ?? '';

        final healthInfo = user['health_info'] as Map<String, dynamic>?;
        if (healthInfo != null) {
          _allergiesController.text = healthInfo['allergies'] ?? '';
          _chronicConditionsController.text = healthInfo['chronic_conditions'] ?? '';
          _currentMedicationsController.text = healthInfo['current_medications'] ?? '';
          _heightController.text = healthInfo['height']?.toString() ?? '';
          _weightController.text = healthInfo['weight']?.toString() ?? '';
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.save),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Personal Information", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth', border: OutlineInputBorder()),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 30),

              Text("Contact Information", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'District', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emergencyContactController,
                decoration: InputDecoration(labelText: 'Emergency Contact', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),

              Text("Health Information", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: 'Allergies', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _chronicConditionsController,
                decoration: InputDecoration(labelText: 'Chronic Conditions', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _currentMedicationsController,
                decoration: InputDecoration(labelText: 'Current Medications', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
