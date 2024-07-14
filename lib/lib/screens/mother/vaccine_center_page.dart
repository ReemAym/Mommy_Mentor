import 'package:flutter/material.dart';
import '../../component/vaccine_center_card.dart';
import '../../models/app_colors.dart';
import '../../models/vaccine_center.dart';
import '../../services/vaccine_center_service.dart';

class VaccineCenterPage extends StatelessWidget {
  final String address;
  final String? token;

  VaccineCenterPage({required this.address, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Vaccine Centers near you',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<VaccineCenter>>(
        future: VaccineCenterService.fetchVaccineCenters(address, token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No vaccine centers found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final center = snapshot.data![index];
                return VaccineCenterCard(
                  vaccinecenterName: center.name,
                  phone: center.phone,
                  address: center.address,
                );
              },
            );
          }
        },
      ),
    );
  }
}
