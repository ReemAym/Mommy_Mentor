import 'package:flutter/material.dart';
import '../models/app_colors.dart';
import '../models/vaccine.dart';
import '../screens/admin/edit_vaccine_screen.dart';
import 'small_button.dart';
import '../../services/vaccine_service.dart';

class ModifyVaccine extends StatelessWidget {
  final String vaccinename;
  final String administrationMethod;
  final String dosage;
  final List<String> diseases;
  final int age;
  final String id;
  final Function(String) onDelete;

  const ModifyVaccine({
    super.key,
    required this.vaccinename,
    required this.administrationMethod,
    required this.dosage,
    required this.diseases,
    required this.age,
    required this.id,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.secondaryColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vaccinename,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Text(
            getFormattedAge(age),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Diseases it protects against: ${diseases.join(', ')}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Administration Method: $administrationMethod',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Dosage: $dosage',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SmallButton(
                text: 'Edit',
                background_color: Colors.white,
                text_color: AppColors.primaryColor,
                onTap: () {
                  Vaccine vaccine = Vaccine(
                    vaccinename: vaccinename,
                    administrationMethod: administrationMethod,
                    dosage: dosage,
                    diseases: diseases,
                    age: age,
                    id: id,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditVaccineScreen(vaccine: vaccine),
                    ),
                  );
                },
              ),
              SmallButton(
                text: 'Delete',
                background_color: Colors.white,
                text_color: AppColors.primaryColor,
                onTap: () async {
                  try {
                    await VaccineService().deleteVaccine(id);
                    onDelete(id); // Notify parent to refresh the list
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete vaccine: $e'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getFormattedAge(int ageInMonths) {
  final years = ageInMonths ~/ 12;
  final months = ageInMonths % 12;
  if (years > 0 && months > 0) {
    return '$years years and $months months';
  } else if (years > 0) {
    return '$years years';
  } else {
    return '$months months';
  }
}
