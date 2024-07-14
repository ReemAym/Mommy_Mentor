import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Add this import for JSON decoding

import '../../component/button.dart';
import '../../models/app_colors.dart';

class JaundicePredictor extends StatefulWidget {
  @override
  _JaundicePredictorState createState() => _JaundicePredictorState();
}

class _JaundicePredictorState extends State<JaundicePredictor> {
  File? _imageFile;
  String _response = '';

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  // Function to upload image to Flask server
  Future<void> _sendRequest() async {
    if (_imageFile == null) return;

    final request =
        http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/predict'));
    request.files
        .add(await http.MultipartFile.fromPath('file', _imageFile!.path));  // Changed 'image' to 'file'

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> decodedResponse = jsonDecode(responseData);  // Decode JSON response
      setState(() {
        _response = decodedResponse['prediction'] ?? 'No prediction found';
      });
    } else {
      setState(() {
        _response = 'Error: ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jaundice Predictor',
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Test Photo'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
              color: AppColors.primaryColor,
            ),
            _imageFile != null
                ? SizedBox(
                    height: 350,
                    child: Center(
                        child:
                            Image.file(_imageFile!))) // Show the selected image
                : const SizedBox(
                    height: 350,
                    child: Center(
                      child: Text('No image selected'),
                    ),
                  ), // Show a message if no image is selected
            const SizedBox(
              height: 20,
            ),
            Button(
              text: 'Submit',
              background_color: AppColors.primaryColor,
              text_color: Colors.white,
              onTap: _sendRequest,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              _response,
              style: const TextStyle(fontSize: 27),
            ),
          ],
        ),
      ),
    );
  }
}
