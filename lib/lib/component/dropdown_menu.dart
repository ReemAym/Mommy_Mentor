import 'package:flutter/material.dart';

import '../models/app_colors.dart';

class DropdownField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String initialValue;

  const DropdownField({super.key, 
    required this.icon,
    required this.label,
    required this.initialValue,
  });

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: AppColors.primaryColor),
          labelText: widget.label,
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedValue = newValue;
                });
              }
            },
            items: <String>['English', 'Arabic']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

