import 'package:flutter/material.dart';

import '../models/app_colors.dart';

class PasswordField extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const PasswordField({super.key, this.initialValue, required this.onChanged});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Default to true to hide the password
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          onChanged: (value) {
            widget.onChanged(value);
            _formKey.currentState?.validate();
          },
          validator: _validatePassword,
          decoration: InputDecoration(
            prefixIcon:const Icon(Icons.lock, color: AppColors.primaryColor),
            labelText: 'Password:',
            labelStyle: const TextStyle(color: AppColors.primaryColor),
            border:const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
