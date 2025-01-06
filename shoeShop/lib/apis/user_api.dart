import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserApi {
  static String server = 'thirty-rockets-yell.loca.lt'; // Gebruik dit voor Android Emulator

  static Future<User?> login(String email, String password) async {
    var url = Uri.https(server, '/users');
    final response = await http.get(url); // Gebruik een GET-aanroep

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      for (var userJson in jsonResponse) {
        if (userJson['email'] == email && userJson['password'] == password) {
          return User.fromJson(userJson);
        }
      }
      // Als er geen match is:
      throw Exception('Onjuiste e-mail of wachtwoord.');
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }
}
