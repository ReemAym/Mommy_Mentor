import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/doctor.dart';
import '../models/mother.dart';

class EditProfileService {
  final String baseUrl=Constant.serverAddress;
Future<Map<String, dynamic>> updateMotherProfile(Mother mother) async {
    final url = Uri.parse('$baseUrl/mother/${mother.id}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${mother.token}', // Add the token to the header
      },
      body: jsonEncode({
        'name': mother.name,
        'address': mother.address,
        'email': mother.email, // Include email in the request body
        'password': mother.password,
      }),
    );
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  Future<bool> updateDoctorProfile(Doctor doctor) async {
    final url = Uri.parse('$baseUrl/doctor/');
    final response = await http.put(//*********** */
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${doctor.token}', // Add the token to the header
      },
      body: jsonEncode({
        'firstName': doctor.firstname,
        'lastName': doctor.lastname,
        'specialization': doctor.specialization,
        'phone': doctor.phone,
        'degree': doctor.degree,
        'email': doctor.email,
        'workPlace': doctor.workPlace,
        'password': doctor.password,
        '_id': doctor.id,
      }),
    );

    return response.statusCode == 200;
  }
}
