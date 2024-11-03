import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class PasswordEditText extends StatefulWidget {
  const PasswordEditText({super.key, required this.textLabel,  required this.textController, required this.textHint,});

  final String textLabel;
  final String textHint;
  final TextEditingController textController;


  @override
  State<PasswordEditText> createState() => _PasswordEditTextState(textHint, textLabel);
}

class _PasswordEditTextState extends State<PasswordEditText> {
  bool _isObscure = true;
  String textHint;
  String textLabel;

  _PasswordEditTextState(this.textHint, this.textLabel);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.textController,
        obscureText: _isObscure,
        cursorColor: Colors.blue,
        obscuringCharacter: '•',
        validator: (value) {
          if (value!.isEmpty) {
            return "Field Required";
          }
          else if(value.length < 2){
            return "Password too short";
          }
          else if(value.length > 4){
            return "Password must be 4 characters";
          }
          else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MainTheme.appColors.neutral200,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide.none,
          ),
          hintText: textHint,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColor,
            ),
          ),
          label: Text(
            textLabel,
            style: TextStyle(
                color: MainTheme.appColors.neutral900,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}