import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://clinic.sohojware.dev/api/v1/auth';


Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
    ) async {
  final url = Uri.parse('$_baseUrl/register');

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
  final url = Uri.parse('$_baseUrl/login');

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
