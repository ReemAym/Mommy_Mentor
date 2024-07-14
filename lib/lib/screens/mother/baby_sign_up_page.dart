// import 'dart:html';
import '../../models/mother.dart';
import '../../screens/mother/mother_home_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../component/button.dart';
import '../../component/textfield.dart';
import '../../models/app_colors.dart';
import '../../services/authantication_service.dart';
import '../../component/radio_item.dart';

class BabySignUp extends StatefulWidget {
  final String? motherId;
  final Mother? mother;
  const BabySignUp({super.key, this.motherId, this.mother});

  @override
  State<BabySignUp> createState() => _BabySignUpState();
}

class _BabySignUpState extends State<BabySignUp> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  String _gender = 'Male'; // Default gender selection
  final ApiauthanticateService apiService = ApiauthanticateService();

  Future<void> registerUser() async {
    final userData = {
      'firstname': _firstname.text,
      'lastname': _lastname.text,
      'birthdate': datePickerController.text,
      'gender': _gender,
    };

    final result = await apiService.addBaby(
        userData, widget.motherId!, widget.mother!.token);

    setState(() {
      if (result['success']) {
        print(result['data']);

        final Map<String, dynamic> data = result['data'];

        final Mother mother = Mother.fromJson(data);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MotherHomeScreen(
            baby: mother.babies![mother.currentIndex],
            motherID: widget.motherId,
            mother: mother,
          );
        }));
      } else {
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
                child: Text('OK'),
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
                "Add Your baby's data",
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
                      hintText: 'First Name',
                      icon: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      controller: _firstname,
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                    ),
                    TextBox(
                      hintText: 'Last Name',
                      icon: const Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                      controller: _lastname,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextField(
                        controller: datePickerController,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryColor,
                          ),
                          hintText: "Click here to select date",
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
                        onTap: () => onTapFunction(context: context),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GenderSelection(
                      selectedGender: _gender,
                      onGenderChanged: (String? newGender) {
                        setState(() {
                          _gender = newGender!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Button(
                      text: 'Add baby',
                      background_color: AppColors.primaryColor,
                      text_color: Colors.white,
                      onTap: registerUser,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

TextEditingController datePickerController = TextEditingController();
onTapFunction({required BuildContext context}) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    lastDate: DateTime.now(),
    firstDate: DateTime(2015),
    initialDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primaryColor,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate == null) return;
  datePickerController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
}