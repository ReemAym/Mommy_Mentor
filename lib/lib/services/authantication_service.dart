import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';

class ApiauthanticateService {
  final String baseUrl=Constant.serverAddress;
   final _storage = const FlutterSecureStorage();
  Future<Map<String, dynamic>> registerMother(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mother/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return data;
    } else {
      final error = jsonDecode(response.body)['message'];
      return {
        'success': false,
        'message': error ?? 'Registration failed. Please try again.'
      };
    }
  }
  Future<Map<String, dynamic>> addBaby(
      Map<String, dynamic> userData,String id,String? token) async {
    print(userData);

    final response = await http.post(
      Uri.parse('$baseUrl/mother/$id/babies'),
       headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['message'];
      return {
        'success': false,
        'message': error ?? 'Adding failed. Please try again.'
      };
    }
  }

Future<Map<String, dynamic>> deleteBaby(String babyId, String token) async {
    final url = Uri.parse('$baseUrl/baby/$babyId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete baby');
    }
  }
  
  Future<Map<String, dynamic>> registerDoctor(
      Map<String, dynamic> userData) async {
    // final url = baseUrl;
    //

    final response = await http.post(
      Uri.parse('$baseUrl/doctor/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      final error = jsonDecode(response.body)['message'];
      return {
        'success': false,
        'message': error ?? 'Registration failed. Please try again.'
      };
    }
  }


  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      String token = data['data']['token'];
    

      await _storage.write(key: 'jwtToken', value: token);
      
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return jsonDecode (response.body);
    }
  }
  Future<Map<String, dynamic>> editCurrentIndexForMother(String motherId, int currentIndex,String? token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mother/$motherId/editCurrentIndex'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
      body: jsonEncode({'currentIndex': currentIndex}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message':"failed to select a baby"};
    }
  }
  Future<String?> getToken() async {
    return  _storage.read(key: 'jwtToken');
  }
}
