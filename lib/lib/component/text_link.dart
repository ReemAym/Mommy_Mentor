import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  TextLink({super.key, required this.text, required this.ontap});
  String text;
  VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Text(
        text,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue,
        ),
      ),
    );
  }
}
