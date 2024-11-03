import 'package:flutter/material.dart';
import 'package:khub_mobile/ui/elements/textFields/otp_edit_text.dart';

class OtpGroupField extends StatefulWidget {
  final int fieldCount;
  final bool? obscureText;
  final Function(String) onChange;
  const OtpGroupField({super.key, required this.fieldCount, required this.onChange, this.obscureText});

  @override
  State<OtpGroupField> createState() => _OtpGroupFieldState();
}

class _OtpGroupFieldState extends State<OtpGroupField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.fieldCount, (_) => TextEditingController());

    // Add listeners to each controller to listen for text changes
    for (var controller in _controllers) {
      controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_onTextChanged);
      controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    // Concatenate the text from all controllers
    String otp = _controllers.map((controller) => controller.text).join();
    widget.onChange(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.fieldCount, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: OtpInput(
              _controllers[index],
              index == 0, // Autofocus the first field
              obscureText: widget.obscureText ?? false,
            ),
          ),
        );
      }),
    );
  }
}