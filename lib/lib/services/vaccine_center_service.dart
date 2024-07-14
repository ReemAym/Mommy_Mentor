import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/vaccine_center.dart';

class VaccineCenterService{

    static const String baseUrl = '${Constant.serverAddress}/vaccineCenter';

 static Future<List<VaccineCenter>> fetchVaccineCenters(String address,String? token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inCity?address=$address'),

     headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']['vaccineCenters'];
      return data.map((json) => VaccineCenter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vaccine centers');
    }
  }
}