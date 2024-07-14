import 'package:flutter/material.dart';
import '../models/app_colors.dart';

typedef OnChangedCallback = void Function(String);

class TextFieldEdit extends StatefulWidget {
  final IconData icon;
  final String label;
  final String initialValue;
  final RegExp validCharacters;
  final OnChangedCallback onChanged;

  const TextFieldEdit({
    Key? key,
    required this.icon,
    required this.label,
    required this.initialValue,
    required this.validCharacters,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldEditState createState() => _TextFieldEditState();
}

class _TextFieldEditState extends State<TextFieldEdit> {
  late TextEditingController _controller;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    if (value.isEmpty || !widget.validCharacters.hasMatch(value)) {
      setState(() {
        errorText = 'Invalid input';
      });
    } else {
      setState(() {
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          _validateInput(value);
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: AppColors.primaryColor),
          labelText: widget.label,
          labelStyle:const TextStyle(color: AppColors.primaryColor),
          errorText: errorText,
          border: const OutlineInputBorder(),
          focusedBorder:const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 196, 191, 191),
              width: 2.0,
            ),
          ),
          errorBorder:const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
