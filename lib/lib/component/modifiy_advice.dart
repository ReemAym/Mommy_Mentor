import 'package:flutter/material.dart';

import '../models/advice.dart';
import '../models/app_colors.dart';
import '../screens/admin/edit_advice_page.dart';
import '../services/advice_service.dart';
import 'small_button.dart';

class ModifyAdvice extends StatelessWidget {
  final String title;
  final String content;
  final int age;
  final String id;
  final Function(String) onDelete;

  const ModifyAdvice({
    super.key,
    required this.title,
    required this.content,
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
            title,
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
            content,
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
                  Advice advice = Advice(
                    title: title,
                    content: content,
                    age: age,
                    id: id,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAdviceScreen(advice: advice),
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
                    await AdviceService().deleteAdvice(id);
                    onDelete(id); // Notify parent to refresh the list
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete advice: $e'),
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
    return '$years year(s) and $months month(s)';
  } else if (years > 0) {
    return '$years year(s)';
  } else {
    return '$months month(s)';
  }
}
