import 'package:flutter/material.dart';
import 'package:task1/screens/mother/predict_jaundice.dart';
import '../../component/button.dart';
import '../../models/app_colors.dart';
import 'predict_diagnosis.dart';
import 'predict_down.dart';
// import 'predict_jaundice.dart'; // Assuming this is the correct import for the jaundice screen

class ChooseModel extends StatelessWidget {
  const ChooseModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check Diseases",
          style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView( // Added SingleChildScrollView to handle overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 const Text(
                  "Check your baby's health",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Divider(
                      thickness: 2,
                      color: AppColors.primaryColor,
                    ),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  child: Image.asset(
                    'assets/image/baby2.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 30),
                 const Divider(
                      thickness: 2,
                      color: AppColors.primaryColor,
                    ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Diagnosis();
                      }));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.medical_services, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Diagnoses of Illnesses",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return DownPredictor();
                      }));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.child_care, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Down Syndrome",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return JaundicePredictor(); // Corrected to JaundicePredictor
                      }));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.child_care, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Jaundice",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
