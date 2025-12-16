import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getDoctors() async {
  final url = Uri.parse('https://doctor.sohojware.dev/api/v1/doctors?specialty=&location=&search=&per_page=15');

  try {
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return {'success': true, 'data': json.decode(response.body)};
    } else {
      try {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to load doctors.',
        };
      } catch (e) {
        return {
          'success': false,
          'message': "An error occurred on the server. Status code: ${response.statusCode}"
        };
      }
    }
  } on TimeoutException {
    return {'success': false, 'message': 'The request timed out. Please try again.'};
  } catch (e) {
    return {'success': false, 'message': 'An unexpected error occurred: $e'};
  }
}
