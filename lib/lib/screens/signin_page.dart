import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/text_link.dart';
import '../component/textfield.dart';
import '../component/button.dart';
import '../models/app_colors.dart';
import '../models/doctor.dart';
import '../models/mother.dart';
import '../providers/auth_provider.dart';
import '../screens/choose_account_page.dart';
import '../services/all_users_service.dart';
import '../services/authantication_service.dart';
import 'doctor/doctor_home_screen.dart';
import 'mother/mother_home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiauthanticateService _apiService =
      ApiauthanticateService();

  void _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    try {
      final result = await _apiService.signIn(email, password);

      if (result['status'] == "success" && result['type']== "mother") {
        final Map<String, dynamic> data = result['data'];
        final Mother mother = Mother.fromJson(data);
        // Set login data in AuthProvider
        Provider.of<AuthProvider>(context, listen: false)
            .setLoginData(mother, password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MotherHomeScreen(
              baby: mother.babies![mother.currentIndex],
              motherID: mother.id,
              mother: mother,
              password: password,
              
            ),
          ),
        );

//update online status
        AllUsersService onlineService = AllUsersService();
        await onlineService.updateMotherStatus(mother.id, true,mother.token);

      } else if (result['status'] == "success" &&
          result['type']== "doctor") {
        final Map<String, dynamic> data = result['data'];
        final Doctor doctor = Doctor.fromJson(data);

        // Set login data in AuthProvider
        Provider.of<AuthProvider>(context, listen: false)
            .setLoginData(doctor, password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorHomeScreen(
              doctorId: result['data']['_id'],
              password: password,
              doctor: doctor,
            ),
          ),
        );

        AllUsersService onlineService = AllUsersService();
        await onlineService.updateDoctorStatus(doctor.id, true,doctor.token);

      } else {
        final error = result['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Try again : $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:const IconThemeData(color: AppColors.primaryColor),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      thickness: 2,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 40),
                    Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextBox(
                            hintText: 'Email',
                            icon: const Icon(
                              Icons.email,
                              color: AppColors.primaryColor,
                            ),
                            validCharacters: RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              caseSensitive: false,
                              multiLine: false,
                            ),
                            controller: _emailController,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: AppColors.primaryColor,
                                ),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 196, 191, 191),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 25),
                          Button(
                            text: 'Sign In',
                            background_color: AppColors.primaryColor,
                            text_color: const Color.fromRGBO(255, 255, 255, 1),
                            onTap: _signIn,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black38,
                                ),
                              ),
                              TextLink(
                                text: 'Sign up',
                                ontap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const ChooseAccount();
                                      },
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
