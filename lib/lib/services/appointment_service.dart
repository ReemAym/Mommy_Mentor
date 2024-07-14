import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/appointment.dart';

class AppointmentService {
  static const String apiUrl = '${Constant.serverAddress}/appointment'; // Update with your backend URL
  
  Future<void> addAppointment(Appointment appointment,String? token) async {
    
    final response = await http.post(
      Uri.parse('$apiUrl/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
      body: json.encode({
        'address': appointment.location,
        'fee': appointment.fees,
        'date': appointment.time,
        // 'token': '123e4567-e89b-12d3-a456-426614174000', // Replace with a valid token or generate it
        'doctor': appointment.doctorId// Replace with the actual doctor ID
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add appointment');
    }
  }

  Future<List<Appointment>> fetchAppointments(String? token) async {
    final response = await http.get(Uri.parse('$apiUrl'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  // Future<List<Appointment>> searchAppointments({String? name, String? location, double? fees}) async {
  //   final Map<String, dynamic> filters = {
  //     if (name != null && name.isNotEmpty) 'doctorName': name,
  //     if (location != null && location.isNotEmpty) 'address': location,
  //     if (fees != null && fees > 0) 'fee': fees.toString(), // Ensure fee is a string
  //   };

  //   final response = await http.post(
  //     Uri.parse('$apiUrl/search'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(filters),
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body)['data'];
  //     return data.map((json) => Appointment.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to search appointments');
  //   }
  // }
}
