import 'dart:convert';
import '../constants.dart';
import 'package:http/http.dart' as http;

import '../models/vaccine.dart';

class VaccineService {
  static const String baseUrl = '${Constant.serverAddress}/vaccine';

  Future<List<Vaccine>> fetchVaccineByAge(int age,String? token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/age/$age'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          List data = jsonResponse['data'];
          return data.map((item) => Vaccine.fromJson(item)).toList();
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception(
            'Failed to load vaccine, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vaccine data: $e');
      throw e;
    }
  }

  Future<List<Vaccine>> fetchAllVaccine() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          List data = jsonResponse['data'];
          return data.map((item) => Vaccine.fromJson(item)).toList();
        } else {
          throw Exception('Key "data" not found in response');
        }
      } else {
        throw Exception(
            'Failed to load vaccine, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vaccine data: $e');
      throw e;
    }
  }

  Future<bool> addVaccine(Vaccine vaccine) async {
    final url = Uri.parse('$baseUrl/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vaccine.toJson()),
    );

    return response.statusCode == 201;
  }

  Future<bool> editVaccine(Vaccine vaccine) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${vaccine.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vaccine.toJson()),
    );

    return response.statusCode == 200;
  }

    Future<void> deleteVaccine(String id) async {
    final url = Uri.parse('$baseUrl/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete vaccine');
    }
  }
}

extension on Vaccine {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'vaccine': vaccinename,
      'adminstrationMethod': administrationMethod,
      'dosage': dosage,
      'diseases': diseases,
    };
  }
}
