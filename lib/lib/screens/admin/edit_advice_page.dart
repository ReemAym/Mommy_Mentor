import 'package:flutter/material.dart';

import '../../models/advice.dart';
import '../../models/app_colors.dart';
import '../../services/advice_service.dart';
import '../../component/small_button.dart';

class EditAdviceScreen extends StatefulWidget {
  final Advice advice;

  const EditAdviceScreen({super.key, required this.advice});

  @override
  _EditAdviceScreenState createState() => _EditAdviceScreenState();
}

class _EditAdviceScreenState extends State<EditAdviceScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _ageController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.advice.title);
    _contentController = TextEditingController(text: widget.advice.content);
    _ageController = TextEditingController(text: widget.advice.age.toString());
    _idController = TextEditingController(text: widget.advice.id);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _ageController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _updateAdvice() async {
    String title = _titleController.text;
    String content = _contentController.text;
    int age = int.parse(_ageController.text);
    String id = _idController.text;
    Advice updatedAdvice = Advice(
      title: title,
      content: content,
      age: age,
      id: id,
    );

    try {
      AdviceService service = AdviceService();
      bool success = await service.editAdvice(updatedAdvice);
      if (success) {
        Navigator.pop(context, updatedAdvice);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update advice')),
        );
      }
    } catch (e) {
      print('Failed to update advice: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Advice',
          style: TextStyle(),
        ),
        iconTheme:const  IconThemeData(color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SmallButton(
              text: 'Update Advice',
              background_color: AppColors.primaryColor,
              text_color: Colors.white,
              onTap: _updateAdvice,
            ),
          ],
        ),
      ),
    );
  }
}
