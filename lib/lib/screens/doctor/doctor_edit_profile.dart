import 'package:flutter/material.dart';
import '../../component/button.dart';
import '../../component/doctor_navigation.dart';
import '../../component/password_editfield.dart';
import '../../component/profile_image.dart';
import '../../component/text_field_edit.dart';
import '../../models/app_colors.dart';
import '../../models/doctor.dart';
import '../../services/edit_profile_service.dart';

class DoctorEditProfile extends StatefulWidget {
  DoctorEditProfile({super.key, this.doctor, this.password});
  late Doctor? doctor;
  late String? password;

  @override
  State<DoctorEditProfile> createState() => _DoctorEditProfileState();
}

class _DoctorEditProfileState extends State<DoctorEditProfile> {
  int _currentIndex = 2;
  late String firstName;
  late String lastName;
  late String phone;
  late String email;
  late String specialization;
  late String degree;
  late String address;
  late String password;
  late String id;
  late String token;

  final EditProfileService _editProfileService =
      EditProfileService();

  @override
  void initState() {
    super.initState();
    firstName = widget.doctor?.firstname ?? "";
    lastName = widget.doctor?.lastname ?? "";
    phone = widget.doctor?.phone ?? "";
    email = widget.doctor?.email ?? "";
    specialization = widget.doctor?.specialization ?? "";
    degree = widget.doctor?.degree ?? "";
    address = widget.doctor?.workPlace ?? "";
    password = widget.password ?? "";
    id = widget.doctor?.id ?? "";
        token = widget.doctor?.token ?? "";

  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _saveProfile() async {
    Doctor updatedDoctor = Doctor(
      firstname: firstName,
      lastname: lastName,
      phone: phone,
      email: email,
      specialization: specialization,
      degree: degree,
      workPlace: address,
      password: password,
      id: id,
      token:token,
    );

    bool success = await _editProfileService.updateDoctorProfile(updatedDoctor);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to update profile.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    ProfileImage(),
                    SizedBox(height: 8),
                    Text('$firstName $lastName',
                        style: const TextStyle(
                            fontSize: 24, color: AppColors.primaryColor)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFieldEdit(
                      icon: Icons.person,
                      label: 'First Name:',
                      initialValue: firstName,
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                      onChanged: (value) => setState(() => firstName = value),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFieldEdit(
                      icon: Icons.person,
                      label: 'Second Name:',
                      initialValue: lastName,
                      validCharacters: RegExp(r'^[a-zA-Z]+$'),
                      onChanged: (value) => setState(() => lastName = value),
                    ),
                  ),
                ],
              ),
              TextFieldEdit(
                icon: Icons.phone,
                label: 'Phone:',
                initialValue: phone,
                validCharacters: RegExp(r'^[0-9]+$'),
                onChanged: (value) => setState(() => phone = value),
              ),
              TextFieldEdit(
                icon: Icons.email,
                label: 'Email:',
                initialValue: email,
                validCharacters: RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  caseSensitive: false,
                  multiLine: false,
                ),
                onChanged: (value) => setState(() => email = value),
              ),
              TextFieldEdit(
                icon: Icons.person,
                label: 'Specialization:',
                initialValue: specialization,
                validCharacters: RegExp(r'^[a-zA-Z]+$'),
                onChanged: (value) => setState(() => specialization = value),
              ),
              TextFieldEdit(
                icon: Icons.person,
                label: 'Degree:',
                initialValue: degree,
                validCharacters: RegExp(r'^[a-zA-Z]+$'),
                onChanged: (value) => setState(() => degree = value),
              ),
              TextFieldEdit(
                icon: Icons.location_on,
                label: 'Address:',
                initialValue: address,
                validCharacters: RegExp(r'^[a-zA-Z0-9\s\-\/\\]+$'),
                onChanged: (value) => setState(() => address = value),
              ),
              const SizedBox(height: 24),
              PasswordField(
                initialValue: password,
                onChanged: (value) => setState(() => password = value),
              ),
              Button(
                  text: 'Save & Follow',
                  background_color: AppColors.primaryColor,
                  text_color: Colors.white,
                  onTap: _saveProfile)
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorNavigationBar(
        doctorID: id,
        currentIndex: _currentIndex,
        password: password,
        onTap: _onItemTapped,
        doctor: Doctor(firstname: firstName, lastname: lastName, phone: phone, specialization: specialization, degree: degree, workPlace: address, email: email, password: password, id: id, token: token),
      ),
    );
  }
}
