import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';



class AllUsersService {
 final String mothersUrl = '${Constant.serverAddress}/mother';
  final String doctorsUrl = '${Constant.serverAddress}/doctor';

  
  Future<Map<String, dynamic>> fetchMothers() async {
    final response = await http.get(Uri.parse('$mothersUrl/all'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load mothers');
    }
  }

  Future<Map<String, dynamic>> fetchDoctors() async {
    final response = await http.get(Uri.parse('$doctorsUrl/all'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load doctors');
    }
  }

   Future<void> deleteMother(String id) async {
    final response = await http.delete(Uri.parse('$mothersUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete mother');
    }
  }

  Future<void> deleteDoctor(String id) async {
    final response = await http.delete(Uri.parse('$doctorsUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }

  Future<bool> updateDoctorStatus(String doctorId, bool online,String token) async {
    final url = Uri.parse('$doctorsUrl/$doctorId/status');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode({
        'online': online,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update doctor status');
    }
  }

   Future<bool> updateMotherStatus(String motherId, bool online,String token) async {
    final url = Uri.parse('$mothersUrl/$motherId/status');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'online': online,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update mother status');
    }
  }
}
