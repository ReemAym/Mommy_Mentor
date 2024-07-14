import 'package:flutter/material.dart';

import '../../component/small_button.dart';
import '../../models/app_colors.dart';
import '../../models/vaccine.dart';
import '../../services/Vaccine_service.dart';

class AddVaccineScreen extends StatefulWidget {
  @override
  _AddVaccineScreenState createState() => _AddVaccineScreenState();
}

class _AddVaccineScreenState extends State<AddVaccineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vaccinenameController = TextEditingController();
  final _administrationMethodController = TextEditingController();
  final _dosageController = TextEditingController();
  final _diseasesController = TextEditingController();
  final _ageController = TextEditingController();
  final _idController =
      TextEditingController(); //do clear or not matter also ia advice

  @override
  void dispose() {
    _vaccinenameController.dispose();
    _administrationMethodController.dispose();
    _dosageController.dispose();
    _diseasesController.dispose();
    _ageController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final vaccine = Vaccine(
        vaccinename: _vaccinenameController.text,
        administrationMethod: _administrationMethodController.text,
        dosage: _dosageController.text,
        diseases: _diseasesController.text.split(','),
        age: int.parse(_ageController.text),
        id: _idController.text,
      );

      // Create an instance of VaccineService
      final vaccineService = VaccineService();

      // Call addVaccine on the instance
      final success = await vaccineService.addVaccine(vaccine);

      if (success) {
        print('${vaccine.id}*******************************');
        _vaccinenameController.clear();
        _administrationMethodController.clear();
        _dosageController.clear();
        _diseasesController.clear();
        _ageController.clear();
        _idController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaccine added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add vaccine')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Add Vaccine',
        ),
        iconTheme:const IconThemeData(color: AppColors.primaryColor),
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
                      controller: _vaccinenameController,
                      decoration:const InputDecoration(
                        labelText: 'Vaccine Name',
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the vaccine name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _administrationMethodController,
                      decoration:const InputDecoration(
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                        labelText: 'Administration Method',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the administration method';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                        labelText: 'Dosage',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the dosage';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _diseasesController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                        labelText: 'Diseases (comma separated)',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the diseases';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                        labelText: 'Age (months)',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
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
                      text: 'Add Vaccine',
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
