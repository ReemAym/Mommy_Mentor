import 'baby_sign_up_page.dart';
import 'package:flutter/material.dart';
import '../../component/button.dart';
import '../../component/text_link.dart';
import '../../component/textfield.dart';
import '../../models/app_colors.dart';
import '../../models/mother.dart';
import '../signin_page.dart';
import '../../services/authantication_service.dart';


class MotherSignUp extends StatefulWidget {
  const MotherSignUp({super.key});

  @override
  State<MotherSignUp> createState() => _MotherSignUpState();
}

class _MotherSignUpState extends State<MotherSignUp> {
  bool _obscureText = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final ApiauthanticateService apiService =
      ApiauthanticateService();

  Future<void> registerUser() async {
    final userData = {
      'name': _name.text,
      'address': _address.text,
      'email': _email.text,
      'password': _password.text,
    };

    final result = await apiService.registerMother(userData);

    setState(() {
      if (result['success']) {
       
        final Map<String, dynamic> data = result['data'];
        final Mother mother = Mother.fromJson(data);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BabySignUp(
            motherId: result['data']['_id']!,
            mother: mother,
          );
        }));
      } else {
       
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:const Text('Error'),
            content: Text(result['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
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
                    TextBox(
                      hintText: 'Name',
                      icon: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      controller: _name,
                      validCharacters: RegExp(r'^[a-zA-Z\s]+$'),

                      // onChangeInput: (value){},
                    ),
                    TextBox(
                      hintText: 'Address',
                      icon: const Icon(
                        Icons.location_city,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[a-zA-Z0-9\s,\/\\\-]+$'),
                      controller: _address,
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
                      controller: _email,
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
                    const SizedBox(
                      height: 32,
                    ),
                    Button(
                        text: 'Continue',
                        background_color: AppColors.primaryColor,
                        text_color: Colors.white,
                        onTap: registerUser)
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
                      text: 'Sign in',
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
