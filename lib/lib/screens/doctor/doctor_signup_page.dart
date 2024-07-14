import 'package:flutter/material.dart';
import '../../component/textfield.dart';
import '../../component/button.dart';
import '../../component/text_link.dart';
import '../../models/app_colors.dart';
import '../../services/authantication_service.dart';
import '../signin_page.dart';

class DoctorSignUp extends StatefulWidget {
  const DoctorSignUp({Key? key}) : super(key: key);

  @override
  State<DoctorSignUp> createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  bool _obscureText = true;

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

final ApiauthanticateService apiService =
      ApiauthanticateService();

  Future<void> _createDoctorAccount() async {
  final userData = {
    'firstName': _firstname.text,
    'lastName': _lastname.text,
    'phone': _phoneNumberController.text,
    'specialization': _specialization.text,
    'degree': _degree.text,
    'workPlace': _addressController.text,
    'email': _emailController.text,
    'password': _password.text,
  };

  final result = await apiService.registerDoctor(userData);

  setState(() {
    if (result['success']) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SignIn();
      }));
    } else {
      print(result['success']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(result['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  });

  print(result);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                color: AppColors.primaryColor,
              ),
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextBox(
                            hintText: 'First Name',
                            icon: const Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                            ),
                            validCharacters: RegExp(r'^[a-zA-Z]+$'),
                            controller: _firstname,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextBox(
                            hintText: 'Last Name',
                            icon: const Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                            ),
                            validCharacters: RegExp(r'^[a-zA-Z]+$'),
                             controller: _lastname,
                          ),
                        )
                      ],
                    ),
                    TextBox(
                      hintText: 'Phone Number',
                      icon: const Icon(
                        Icons.phone,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[0-9]+$'),
                      controller: _phoneNumberController,
                    ),
                    TextBox(
                      hintText: 'Specialization',
                      icon: const Icon(
                        Icons.adjust,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                       controller: _specialization,
                    ),
                    TextBox(
                      hintText: 'Degree',
                      icon: const Icon(
                        Icons.label_rounded,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                       controller: _degree,
                    ),
                    TextBox(
                      hintText: 'Workplace',
                      icon: const Icon(
                        Icons.local_hospital_sharp,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[a-zA-Z0-9\s]+$'),
                       controller: _addressController,
                    ),
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.primaryColor,
                        ),
                        suffixIcon: GestureDetector(
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
                    const SizedBox(height: 32),
                    Button(
                        text: 'Sing Up',
                        background_color: AppColors.primaryColor,
                        text_color: Colors.white,
                        onTap: _createDoctorAccount),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  TextLink(
                      text: 'Sign In',
                      ontap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignIn();
                        }));
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
