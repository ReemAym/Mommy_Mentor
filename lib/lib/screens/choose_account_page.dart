import 'package:flutter/material.dart';
import '../component/button.dart';
import '../models/app_colors.dart';
import 'doctor/doctor_signup_page.dart';
import 'mother/mother_signup_page.dart';


class ChooseAccount extends StatelessWidget {
  const ChooseAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Create Account',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme:const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Container(
          width: 400,
          decoration:const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.primaryColor])),
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              const Image(
                image: AssetImage('assets/image/mother.png'),
              ),
              const Spacer(
                flex: 1,
              ),
              Button(
                  text: 'Mother',
                  background_color: Colors.white,
                  text_color: Colors.black,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MotherSignUp();
                    }));
                  }),
              const Spacer(
                flex: 2,
               ),
              const Image(
                image: AssetImage('assets/image/doctor.png'),
              ),
              const Spacer(
                flex: 1,
              ),
              Button(
                  text: 'Doctor',
                  background_color: Colors.white,
                  text_color: Colors.black,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const DoctorSignUp();
                    }));
                  }),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
