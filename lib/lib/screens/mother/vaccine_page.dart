import 'package:flutter/material.dart';
import '../../component/vaccine_card.dart';
import '../../models/app_colors.dart';
import '../../models/vaccine.dart';
import '../../models/baby.dart';
import '../../services/vaccine_service.dart';

class VaccinePage extends StatefulWidget {
  final Baby? baby;
  final String? token;
  const VaccinePage({super.key, this.baby, this.token});

  @override
  State<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  List<Vaccine> vaccineList = [];
  bool isLoading = true;
  Baby? mother;
  DateTime? babyDate;

  @override
  void initState() {
    super.initState();
    mother = widget.baby;
    babyDate = mother?.birthdate ?? DateTime.now();
    fetchVaccine();
  }

  void fetchVaccine() async {
    VaccineService service = VaccineService();
    try {
      final age = calculateAgeInMonths(babyDate!);
      final response = await service.fetchVaccineByAge(age, widget.token);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vaccine',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // const Divider(
                    //   thickness: 2,
                    //   color: AppColors.primaryColor,
                    // ),
                    // SizedBox(height: 15),
                    vaccineList.isEmpty
                        ?const Center(child: Text('No vaccine yet'))
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView(
                              children: vaccineList
                                  .map((vaccine) => VaccineCard(
                                        vaccinename: vaccine.vaccinename,
                                        administrationMethod:
                                            vaccine.administrationMethod,
                                        dosage: vaccine.dosage,
                                        diseases: vaccine.diseases,
                                        age: calculateAgeInMonths(babyDate!),
                                      ))
                                  .toList(),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}

int calculateAgeInMonths(DateTime birthdate) {
  DateTime today = DateTime.now();
  int years = today.year - birthdate.year;
  int months = today.month - birthdate.month;

  if (months < 0) {
    years--;
    months += 12;
  }

  return years * 12 + months;
}
