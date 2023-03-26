import 'dart:convert';
import 'package:carparkapp/pages/User.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://20.187.121.122';
  var client = http.Client();

  static Future<String?> login(User user) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(url, body: jsonEncode(user.toJson()));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['access_token'];
    } else {
      return null;
    }
  }

}
