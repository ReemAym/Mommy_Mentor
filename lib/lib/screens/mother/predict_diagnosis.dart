import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../component/message_box.dart';
import '../../models/app_colors.dart';


class Diagnosis extends StatefulWidget {
  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  bool _showSecondQuestion = false;
  bool _showThirdQuestion = false;
  bool _showFourthQuestion = false;
  bool _showFifthQuestion = false;
  bool _showSixthQuestion = false;
  bool _showSeventhQuestion = false;

  String ans1 = '';
  String ans2 = '';
  String ans3 = '';
  String ans4 = '';
  String ans5 = '';
  String ans6 = '';
  String diagnosis = '';

  Future<void> sendRequest() async {
    var url = Uri.parse('http://10.0.2.2:5000/predict');

    var data = {
      'cough': ans1,
      'runny_nose': ans2,
      'rash': ans3,
      'difficulty_breathing': ans4,
      'loss_of_appetite': ans5,
      'irritability': ans6,
    };
    print('Sending request to: $url');
    print('Request body: $data');
    try {
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          diagnosis = jsonDecode(response.body)['predicted_diagnosis'];
          print('Request with status: ${response.body}');
          print(response.statusCode);
        });
      } else {
        // Handle HTTP error status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Exception occurred while sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Diagnosis Predictor",
          style: TextStyle(
              // color: AppColors.primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageBox(
                message: 'Does the baby have a cough?',
                ans: ans1,
                showNext: !_showSecondQuestion,
                onShowNextChanged: (value, value2) {
                  setState(() {
                    _showSecondQuestion = value;
                    ans1 = value2;
                    // Call sendRequest when all questions are answered
                    if (_showSecondQuestion && _showSeventhQuestion) {
                      sendRequest();
                    }
                  });
                },
              ),
              const SizedBox(height: 16.0),
              if (_showSecondQuestion)
                MessageBox(
                  message: 'Does the baby have a runny nose?',
                  ans: ans2,
                  showNext: !_showThirdQuestion,
                  onShowNextChanged: (value, value2) {
                    setState(() {
                      _showThirdQuestion = value;
                      ans2 = value2;
                      // Call sendRequest when all questions are answered
                      if (_showThirdQuestion && _showSeventhQuestion) {
                        sendRequest();
                      }
                    });
                  },
                ),
              const SizedBox(height: 16.0),
              if (_showThirdQuestion)
                MessageBox(
                  message: 'Does the baby have a rash?',
                  ans: ans3,
                  showNext: !_showFourthQuestion,
                  onShowNextChanged: (value, value2) {
                    setState(() {
                      _showFourthQuestion = value;
                      ans3 = value2;
                      // Call sendRequest when all questions are answered
                      if (_showFourthQuestion && _showSeventhQuestion) {
                        sendRequest();
                      }
                    });
                  },
                ),
             const SizedBox(height: 16.0),
              if (_showFourthQuestion)
                MessageBox(
                  message: 'Does the baby have difficulty breathing?',
                  ans: ans4,
                  showNext: !_showFifthQuestion,
                  onShowNextChanged: (value, value2) {
                    setState(() {
                      _showFifthQuestion = value;
                      ans4 = value2;
                      // Call sendRequest when all questions are answered
                      if (_showFifthQuestion && _showSeventhQuestion) {
                        sendRequest();
                      }
                    });
                  },
                ),
              const SizedBox(height: 16.0),
              if (_showFifthQuestion)
                MessageBox(
                  message: 'Does the baby have a loss of appetite?',
                  ans: ans5,
                  showNext: !_showSixthQuestion,
                  onShowNextChanged: (value, value2) {
                    setState(() {
                      _showSixthQuestion = value;
                      ans5 = value2;
                      // Call sendRequest when all questions are answered
                      if (_showSixthQuestion && _showSeventhQuestion) {
                        sendRequest();
                      }
                    });
                  },
                ),
             const SizedBox(height: 16.0),
              if (_showSixthQuestion)
                MessageBox(
                  message: 'Does the baby have irritability?',
                  ans: ans6,
                  showNext: !_showSeventhQuestion,
                  onShowNextChanged: (value, value2) {
                    setState(() {
                      _showSeventhQuestion = value;
                      ans6 = value2;
                      // Call sendRequest when all questions are answered
                      if (_showSeventhQuestion && _showSeventhQuestion) {
                        sendRequest();
                      }
                    });
                  },
                ),
             const SizedBox(height: 16.0),
              if (_showSeventhQuestion)
                Text(
                  'Predicted Diagnosis: $diagnosis',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
