import 'package:flutter/material.dart';


import '../../component/small_button.dart';
import '../../models/app_colors.dart';
import '../../models/vaccine.dart';
import '../../services/Vaccine_service.dart';

class EditVaccineScreen extends StatefulWidget {
  final Vaccine vaccine;

  const EditVaccineScreen({super.key, required this.vaccine});

  @override
  _EditVaccineScreenState createState() => _EditVaccineScreenState();
}

class _EditVaccineScreenState extends State<EditVaccineScreen> {
  late TextEditingController _vaccineNameController;
  late TextEditingController _administrationMethodController;
  late TextEditingController _dosageController;
  late TextEditingController _diseasesController;
  late TextEditingController _ageController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _vaccineNameController =
        TextEditingController(text: widget.vaccine.vaccinename);
    _administrationMethodController =
        TextEditingController(text: widget.vaccine.administrationMethod);
    _dosageController = TextEditingController(text: widget.vaccine.dosage);
    _diseasesController =
        TextEditingController(text: widget.vaccine.diseases.join(', '));
    _ageController = TextEditingController(text: widget.vaccine.age.toString());
    _idController = TextEditingController(text: widget.vaccine.id);
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _administrationMethodController.dispose();
    _dosageController.dispose();
    _diseasesController.dispose();
    _ageController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _updateVaccine() async {
    String vaccineName = _vaccineNameController.text;
    String administrationMethod = _administrationMethodController.text;
    String dosage = _dosageController.text;
    List<String> diseases = _diseasesController.text.split(', ').toList();
    int age = int.parse(_ageController.text);
    String id = _idController.text;
    Vaccine updatedVaccine = Vaccine(
      vaccinename: vaccineName,
      administrationMethod: administrationMethod,
      dosage: dosage,
      diseases: diseases,
      age: age,
      id: id,
    );

    try {
      VaccineService service = VaccineService();
      bool success = await service.editVaccine(updatedVaccine);
      if (success) {
        Navigator.pop(context, updatedVaccine);
      } else {
        print('Failed to update vaccine: Server returned an error');
      }
    } catch (e) {
      print('Failed to update vaccine: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vaccine'),
        iconTheme:const  IconThemeData(color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vaccineNameController,
              decoration: const InputDecoration(
                labelText: 'Vaccine Name',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                labelStyle: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextField(
              controller: _administrationMethodController,
              decoration: const InputDecoration(
                labelText: 'Administration Method',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                labelStyle: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                labelStyle: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextField(
              controller: _diseasesController,
              decoration: const InputDecoration(
                labelText: 'Diseases',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                labelStyle: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age (months)',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                labelStyle: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            SmallButton(
                text: 'Update Vaccine',
                background_color: AppColors.primaryColor,
                text_color: Colors.white,
                onTap: _updateVaccine)
          ],
        ),
      ),
    );
  }
}
