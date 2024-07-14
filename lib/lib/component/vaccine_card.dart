import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class VaccineCard extends StatelessWidget {
  const VaccineCard({
    super.key,
    required this.vaccinename,
    required this.administrationMethod,
    required this.dosage,
    required this.diseases,
    required this.age,
  });

  final String vaccinename;
  final String administrationMethod;
  final String dosage;
  final List<String> diseases;
  final int age;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccinename,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Diseases it protects against: ${diseases.join(', ')}',
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Administration Method: $administrationMethod',
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Dosage: $dosage',
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getFormattedAge(age),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedAge(int ageInMonths) {
    final years = ageInMonths ~/ 12;
    final months = ageInMonths % 12;
    if (years > 0 && months > 0) {
      return '$years years\n$months months';
    } else if (years > 0) {
      return '$years years';
    } else {
      return '$months months';
    }
  }
}
