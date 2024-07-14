import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/advice.dart';

class AdviceService {
  static const String baseUrl = '${Constant.serverAddress}/advice';

    Future<List<Advice>> fetchAdviceByAgeLang(int age, String language,String? token) async {
    String endpoint = language == 'Arabic' ? 'arabic/age' : 'age';
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/$age'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((advice) => Advice.fromJson(advice)).toList();
    } else {
      throw Exception('Failed to load advice');
    }
  }

  Future<List<Advice>> fetchAllAdvice() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((data) => Advice.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load advice');
    }
  }

  Future<bool> addAdvice(Advice advice) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(advice.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> editAdvice(Advice advice) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${advice.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(advice.toJson()),
    );
    return response.statusCode == 200;
  }

     Future<void> deleteAdvice(String id) async {
    final url = Uri.parse('$baseUrl/$id');

    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete advice');
    }
  }
}
