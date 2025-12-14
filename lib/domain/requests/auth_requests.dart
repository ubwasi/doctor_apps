import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map> login(String email, String password) async {
  var url = Uri.parse('https://martix.greedchronicles.com/api/login');
  var res = await http.post(url, body: {'email': email, 'password': password});

  if (res.statusCode == 200) {
    var data = jsonDecode(res.body) as Map<String, dynamic>;
    var user = data['user'];
    var token = data['token'];
    return {'user': user, 'token': token, 'success': true};
  } else {
    var data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['error'] != null) {
      return {'message': data['error'], 'success': false};
    }
  }
  return {'success': false};
}
