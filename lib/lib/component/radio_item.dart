import 'package:flutter/material.dart';

import '../models/app_colors.dart';

class GenderSelection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Male'),
            value: 'Male',
            activeColor: AppColors.primaryColor,
            groupValue: selectedGender,
            onChanged: onGenderChanged,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Female'),
            value: 'Female',
            activeColor: AppColors.primaryColor,
            groupValue: selectedGender,
            onChanged: onGenderChanged,
          ),
        ),
      ],
    );
  }
}