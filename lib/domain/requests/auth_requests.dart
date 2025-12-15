import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> register(
  String name,
  String email,
  String phone,
  String password,
  String passwordConfirmation,
) async {
  final url = Uri.parse('https://doctor.sohojware.dev/api/v1/auth/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': json.decode(response.body)};
    } else {
      final errorData = json.decode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Registration failed. Please try again.',
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'An unexpected error occurred: $e'};
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('https://doctor.sohojware.dev/api/v1/auth/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': json.decode(response.body)};
    } else {
      final errorData = json.decode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Login failed. Please try again.',
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'An unexpected error occurred: $e'};
  }
}
