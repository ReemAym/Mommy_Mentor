import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class OneAdvice extends StatelessWidget {
  const OneAdvice({
    super.key,
    required this.advice,
    required this.date,
    required this.age,
    required this.content,
    required this.languageCode,
  });

  final String advice;
  final DateTime date;
  final int age;
  final String content;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset:const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${date.year}-${date.month}-${date.day}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  advice,
                  style:const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
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
                  padding: const EdgeInsets.all(8),
                  width: 100, 
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    formatAge(age, languageCode),
                    style:const  TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Adjusted font size to fit new width
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center, // Centered text
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatAge(int months, String languageCode) {
  int years = months ~/ 12;
  int remainingMonths = months % 12;
  String yearsText = years > 0 ? '$years ${getTranslatedText('years', languageCode)}' : '';
  String monthsText = remainingMonths > 0 ? '$remainingMonths ${getTranslatedText('months', languageCode)}' : '';
  return '$yearsText $monthsText'.trim();
}

String getTranslatedText(String key, String languageCode) {
  return translations[languageCode]?[key] ?? key;
}

const Map<String, Map<String, String>> translations = {
  'en': {
    'months': 'months',
    'years': 'years',
  },
  'ar': {
    'months': 'شهور',
    'years': 'سنوات',
  },
};
