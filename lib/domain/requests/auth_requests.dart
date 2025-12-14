import 'package:http/http.dart' as http;

Future<void> login(String email, String password) async {
  var url = Uri.parse('https://angelicalife.no/api/login');
  var res = await http.post(url, body: {
    'email': email,
    'password': password,
  });
  print(res);
}