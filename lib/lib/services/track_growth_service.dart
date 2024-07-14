import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../screens/mother/baby_tracker.dart';
class GrowthTrackService {
  static const String apiUrl = Constant.serverAddress;
  static Future<Map<String, dynamic>> checkNormalGrowth({
    required String gender,
    required String ageInMonths,
    required double weight,
    required double height,
    required double headCircumference,
    required String? token
  }) async {
    try {
       if(gender=="Male"){
      gender="male";
    }
    else if(gender=="Female"){
      gender="female";

    }
      final response = await http.post(
        Uri.parse('$apiUrl/normalGrowth/check'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
        body: jsonEncode({
          'gender': gender,
          'ageInMonths': ageInMonths,
          'weight': weight,
          'height': height,
          'headCircumference': headCircumference,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'weight': responseData['data']['weight'],
          'height': responseData['data']['height'],
          'headCircumference': responseData['data']['headCircumference'],
          'weightNormal':responseData['data']['weightNormal'],
          'heightNormal':responseData['data']['heightNormal'],
          'headCircumferenceNormal':responseData['data']['headCircumferenceNormal'],
        };
      } else {
        throw Exception('Failed to check normal growth: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking normal growth: $e');
    }
  }
  static Future<List<NormalGrowthData>> getNormalGrowthData(String gender, int maxAge,String? token) async {
    if(gender=="Male"){
      gender="male";
    }
    else if(gender=="Female"){
      gender="female";

    }
    final response = await http.get(
      Uri.parse('$apiUrl/normalGrowth?gender=$gender'),
       headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => NormalGrowthData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load normal growth data');
    }
  }
static Future<bool> addGrowthData(String id,GrowthData growthData,String? token) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/baby/measurements/$id'), // Example endpoint, adjust as per your backend API
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
        body: jsonEncode(growthData.toJson()),
      );

      if (response.statusCode == 200 ||response.statusCode == 201) {
        return true; // Successfully added growth data
      } else {
        
        return false; // Failed to add growth data
      }
    } catch (e) {
      return false; // Exception occurred
    }
  }
  static Future<List<GrowthData>> getAllMonthlyMeasurements(String babyId ,String? token) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/baby/measurements/$babyId'),
       headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        List<GrowthData> measurements =
            data.map((json) => GrowthData.fromJson(json)).toList();
        return measurements;
      } else {
        throw Exception('Failed to load growth data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
