import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import '../../component/button.dart';
import '../../component/dropdown_menu.dart';
import '../../component/password_editfield.dart';
import '../../component/profile_image.dart';
import '../../component/text_field_edit.dart';
import '../../models/app_colors.dart';
import '../../models/mother.dart';
import '../../services/edit_profile_service.dart';

class MotherEditProfile extends StatefulWidget {
  final Mother? mother;
  final String? passWord;

  const MotherEditProfile({Key? key, this.mother, this.passWord})
      : super(key: key);

  @override
  State<MotherEditProfile> createState() => _MotherEditProfileState();
}

class _MotherEditProfileState extends State<MotherEditProfile> {
  late String name;
  late String email;
  late String address;
  late String password;

  final _formKey = GlobalKey<FormState>();
  final EditProfileService _apiService = EditProfileService();

  @override
  void initState() {
    super.initState();
    name = widget.mother?.name ?? "";
    email = widget.mother?.email ?? "";
    address = widget.mother?.address ?? "";
    password = widget.passWord ?? "";
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      final updatedMother = Mother(
        name: name,
        address: address,
        email: email,
        password: hashedPassword,
        id: widget.mother!.id,
        token: widget.mother!.token,
        currentIndex: widget.mother!.currentIndex,
      );

      final data = await _apiService.updateMotherProfile(updatedMother);

      if (data['success']) {
        final Mother mother = Mother.fromJson(data['data']);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to update profile')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const ProfileImage(),
                    const SizedBox(height: 8),
                    Text(name,
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
                      label: 'Name:',
                      initialValue: name,
                      validCharacters: RegExp(r'^[a-zA-Z\s]+$'),
                      onChanged: (value) => setState(() => name = value),
                    ),
                  ),
                ],
              ),
              TextFieldEdit(
                icon: Icons.email,
                label: 'Email:',
                initialValue: email,
                validCharacters: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
                onChanged: (value) => setState(() => email = value),
              ),
              PasswordField(
                initialValue: password,
                onChanged: (value) => setState(() => password = value),
              ),
              TextFieldEdit(
                icon: Icons.location_on,
                label: 'Address:',
                initialValue: address,
                validCharacters: RegExp(r'^[a-zA-Z0-9\s,\/\\\-]+$'),
                onChanged: (value) => setState(() => address = value),
              ),
              const DropdownField(
                icon: Icons.language,
                label: 'Language',
                initialValue: 'English',
              ),
              const SizedBox(height: 24),
              Button(
                text: 'Save & Follow',
                background_color: AppColors.primaryColor,
                text_color: Colors.white,
                onTap: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
