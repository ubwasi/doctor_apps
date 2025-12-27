import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _baseUrl = 'https://clinic.sohojware.dev/api/v1';


Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
    ) async {
  final url = Uri.parse('$_baseUrl/auth/register');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': responseBody['data'],
        'message': responseBody['message'],
      };
    }

    return {
      'success': false,
      'message':
      responseBody['message'] ?? 'Registration failed. Please try again.',
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'Unexpected error: $e',
    };
  }
}


Future<Map<String, dynamic>> login(
    String email,
    String password,
    ) async {
  final url = Uri.parse('$_baseUrl/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['success'] == true) {
      return {
        'success': true,
        'data': {
          'user': responseBody['data']['user'],
          'token': responseBody['data']['token'],
        },
        'message': responseBody['message'],
      };
    }

    return {
      'success': false,
      'message':
      responseBody['message'] ?? 'Login failed. Please try again.',
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'Unexpected error: $e',
    };
  }
}

Future<Map<String, dynamic>> updateProfile(
    String name,
    String email,
    String phone,
    String dateOfBirth,
    String gender,
    String bloodGroup,
    String height,
    String weight,
    String bmi,
    String address,
    String city,
    ) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    return {
      'success': false,
      'message': 'User not authenticated',
    };
  }

  final url = Uri.parse('$_baseUrl/profile');

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'blood_group': bloodGroup,
        'address': address,
        'city': city,
        'health_info': {
          'height': height,
          'weight': weight,
          'bmi': bmi,
        }
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await prefs.setString(
        'user',
        jsonEncode(responseBody['data']['user']),
      );

      return {
        'success': true,
        'data': responseBody['data']['user'],
        'message': responseBody['message'],
      };
    }

    return {
      'success': false,
      'message':
      responseBody['message'] ?? 'Update profile failed. Try again.',
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'Unexpected error: $e',
    };
  }
}
