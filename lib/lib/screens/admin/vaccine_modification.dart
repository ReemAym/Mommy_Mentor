import 'package:flutter/material.dart';

import '../../component/modify_vaccine.dart';
import '../../models/app_colors.dart';
import '../../models/vaccine.dart';
import '../../services/vaccine_service.dart';
import 'add_vaccine_page.dart';

class VaccineModification extends StatefulWidget {
  const VaccineModification({super.key});

  @override
  State<VaccineModification> createState() => _VaccineModificationState();
}

class _VaccineModificationState extends State<VaccineModification> {
  List<Vaccine> vaccineList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVaccine();
  }

  void fetchVaccine() async {
    VaccineService service = VaccineService();
    try {
      final response = await service.fetchAllVaccine();
      if (mounted) {
        setState(() {
          vaccineList = response;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load vaccine: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteVaccine(String id) {
    setState(() {
      vaccineList.removeWhere((vaccine) => vaccine.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vaccine',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddVaccineScreen();
              }));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vaccineList.isEmpty
              ?const Center(
                  child: Text(
                    'No vaccine yet',
                    style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: vaccineList.length,
                  itemBuilder: (context, index) {
                    final vaccine = vaccineList[index];
                    return ModifyVaccine(
                      vaccinename: vaccine.vaccinename,
                      administrationMethod: vaccine.administrationMethod,
                      dosage: vaccine.dosage,
                      diseases: vaccine.diseases,
                      age: vaccine.age,
                      id: vaccine.id,
                      onDelete: deleteVaccine,
                    );
                  },
                ),
    );
  }
}
