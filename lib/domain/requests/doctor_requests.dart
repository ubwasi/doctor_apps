import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getDoctors() async {
  final url = Uri.parse(
    'https://doctor.sohojware.dev/api/v1/doctors?specialty=&location=&search=&per_page=15',
  );

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return {
        'success': true,
        'data': jsonData['data'],
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to load doctors',
      };
    }
  } on TimeoutException {
    return {
      'success': false,
      'message': 'Request timeout',
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}
