import 'package:flutter/material.dart';

import '../models/app_colors.dart';

class TextBox extends StatefulWidget {
  final String hintText;
  final Widget icon;
  final Widget? suffixIcon;
  final RegExp validCharacters;
  final TextEditingController controller;

  const TextBox({
    super.key,
    required this.hintText,
    required this.icon,
    this.suffixIcon,
    required this.validCharacters,
    required this.controller,
  });

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // No need to dispose of the controller here as it is passed in
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty || !widget.validCharacters.hasMatch(value)) {
        _errorText = 'Invalid input';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: widget.controller,
        onChanged: _validateInput,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon,
          errorText: _errorText,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
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
    );
  }
}
