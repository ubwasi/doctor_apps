import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/requests/auth_requests.dart';

class ProfileEditingScreen extends StatefulWidget {
  const ProfileEditingScreen({super.key});

  @override
  State<ProfileEditingScreen> createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, dynamic> _user = {};

  // Personal Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodGroupController = TextEditingController();

  // Contact Info
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
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString != null) {
      _user = jsonDecode(userString);
      final health = _user['health_info'] ?? {};

      // Personal Info
      _nameController.text = _user['name'] ?? '';
      _emailController.text = _user['email'] ?? '';
      _phoneController.text = _user['phone'] ?? '';
      _dobController.text = _user['date_of_birth'] ?? '';
      _genderController.text = _user['gender'] ?? '';
      _bloodGroupController.text = _user['blood_group'] ?? '';

      // Contact Info
      _addressController.text = _user['address'] ?? '';
      _cityController.text = _user['city'] ?? '';
      _districtController.text = _user['district'] ?? '';
      _postalCodeController.text = _user['postal_code'] ?? '';
      _emergencyContactController.text = _user['emergency_contact'] ?? '';

      // Health Info
      _allergiesController.text = health['allergies'] ?? '';
      _chronicConditionsController.text = health['chronic_conditions'] ?? '';
      _currentMedicationsController.text = health['current_medications'] ?? '';
      _heightController.text = health['height']?.toString() ?? '';
      _weightController.text = health['weight']?.toString() ?? '';
    }

    if (mounted) setState(() {});
  }

  double _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final bmi =
    (height != null && weight != null) ? _calculateBMI(height, weight) : null;

    final result = await updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      gender: _genderController.text.trim(),
      district: _districtController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      emergencyContact: _emergencyContactController.text.trim(),
      allergies: _allergiesController.text.trim(),
      chronicConditions: _chronicConditionsController.text.trim(),
      currentMedications: _currentMedicationsController.text.trim(),
      bloodGroup: _bloodGroupController.text.trim(),
      height: _heightController.text.trim(),
      weight: _weightController.text.trim(),
      bmi: bmi?.toStringAsFixed(2),
      address: _addressController.text.trim(),
    );



    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      final updatedUser = {
        ..._user,
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "date_of_birth": _dobController.text,
        "gender": _genderController.text,
        "blood_group": _bloodGroupController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "district": _districtController.text,
        "postal_code": _postalCodeController.text,
        "emergency_contact": _emergencyContactController.text,
        "health_info": {
          "allergies": _allergiesController.text,
          "chronic_conditions": _chronicConditionsController.text,
          "current_medications": _currentMedicationsController.text,
          "height": _heightController.text,
          "weight": _weightController.text,
          "bmi": bmi?.toStringAsFixed(2) ?? '',
        }
      };
      await prefs.setString('user', jsonEncode(updatedUser));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Update failed')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
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

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(title, style: Theme.of(context).textTheme.titleLarge),
  );

  Widget _field(TextEditingController controller, String label, {bool isNumber = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          _isLoading
              ? const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(color: Colors.white),
          )
              : IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
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
              _section('Personal Information'),
              _field(_nameController, 'Name'),
              _field(_emailController, 'Email'),
              _field(_phoneController, 'Phone'),
              _field(_dobController, 'Date of Birth'),
              _field(_genderController, 'Gender'),
              _field(_bloodGroupController, 'Blood Group'),

              _section('Contact Information'),
              _field(_addressController, 'Address'),
              _field(_cityController, 'City'),
              _field(_districtController, 'District'),
              _field(_postalCodeController, 'Postal Code', isNumber: true),
              _field(_emergencyContactController, 'Emergency Contact'),

              _section('Health Information'),
              _field(_allergiesController, 'Allergies'),
              _field(_chronicConditionsController, 'Chronic Conditions'),
              _field(_currentMedicationsController, 'Current Medications'),
              _field(_heightController, 'Height (cm)', isNumber: true),
              _field(_weightController, 'Weight (kg)', isNumber: true),
            ],
          ),
        ),
      ),
    );
  }
}
