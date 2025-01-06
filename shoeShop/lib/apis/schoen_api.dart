import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/schoen.dart';

class SchoenApi {
  static String server = 'thirty-rockets-yell.loca.lt'; // Gebruik dit voor Android Emulator

  static Future<List<Schoen>> fetchSchoenen() async {
    var url = Uri.https(server, '/schoenen');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((schoen) => Schoen.fromJson(schoen)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<Schoen> fetchSchoenByID(String shoeID) async {
    final response = await http.get(Uri.parse('url/schoenen/$shoeID'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Schoen.fromJson(data);
    } else {
      throw Exception('Failed to load schoen details');
    }
  }
}
