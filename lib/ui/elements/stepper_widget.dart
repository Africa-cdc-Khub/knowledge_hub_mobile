import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final int stepNumber;
  final String title;

  const StepWidget({super.key,
    required this.isActive,
    required this.isCompleted,
    required this.stepNumber,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive || isCompleted ? Theme.of(context).primaryColor : Colors.grey,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white)
              : Text(
            '$stepNumber',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }
}

class Connector extends StatelessWidget {
  final bool isActive;

  const Connector({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 2,
      width: 50, // Adjust the width to match your design
      height: 2,
      color: isActive ? Theme.of(context).primaryColor : Colors.grey,
    );
  }
}