import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  SmallButton(
      {super.key,
      required this.text,
      required this.background_color,
      required this.text_color,
      required this.onTap});
  String? text;
  Color? background_color;
  Color? text_color;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(background_color),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Set the border radius
          ),
        ),
      ),
      child: Text(
        text!,
        style: TextStyle(fontSize: 16, color: text_color),
      ),
    );
  }
}
