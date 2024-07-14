import 'package:flutter/material.dart';


import '../../component/small_button.dart';
import '../../models/advice.dart';
import '../../models/app_colors.dart';
import '../../services/advice_service.dart';

class AddAdviceScreen extends StatefulWidget {
  @override
  _AddAdviceScreenState createState() => _AddAdviceScreenState();
}

class _AddAdviceScreenState extends State<AddAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final AdviceService _adviceService = AdviceService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final advice = Advice(
        title: _titleController.text,
        content: _contentController.text,
        age: int.parse(_ageController.text),
        id: _idController.text,
      );

      try {
        await _adviceService.addAdvice(advice);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Advice added successfully!')),
        );
        _titleController.clear();
        _contentController.clear();
        _ageController.clear();
        _idController.clear();

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add advice: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Advice',
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      body: Column(
        children: [
          const Divider(color: AppColors.primaryColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SmallButton(
                      text: 'Add Advice',
                      background_color: AppColors.primaryColor,
                      text_color: Colors.white,
                      onTap: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
