import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final bool? obscureText;
  const OtpInput(this.controller, this.autoFocus, {super.key, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        cursorColor: Colors.blue,
        maxLength: 1,
        style:  TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w800
        ),
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            counterText: '',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide.none,
            )),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}