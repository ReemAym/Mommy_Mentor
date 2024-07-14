import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class VaccineCenterCard extends StatelessWidget {
  const VaccineCenterCard({
    super.key,
    required this.vaccinecenterName,
    required this.phone,
    required this.address,
  });

  final String vaccinecenterName;
  final String phone;
  final String address;

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
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vaccinecenterName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_city,
                size: 20,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  address,
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
