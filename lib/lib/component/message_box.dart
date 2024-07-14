import 'package:flutter/material.dart';

import '../models/app_colors.dart';


class MessageBox extends StatefulWidget {
  final String message;
  String ans;
  bool showNext = false;
  final Function(bool, String) onShowNextChanged;

  MessageBox({
    super.key,
    required this.message,
    required this.ans,
    required this.showNext,
    required this.onShowNextChanged,
  });

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.secondaryColor,
      ),
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add space between questions
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.onShowNextChanged(true, 'true');
                    
                  });
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.onShowNextChanged(true, 'false');
                    print('false');
                  });
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
