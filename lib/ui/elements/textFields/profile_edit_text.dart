import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class ProfileEditText extends StatelessWidget {
  const ProfileEditText({
    super.key,
    required this.textHint,
    required this.textController,
    required this.textValidatorType,
    required this.isEditable,
  });

  final String textHint;
  final String? textValidatorType; //validator types: email, password
  final TextEditingController textController;
  final bool isEditable;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        enabled: isEditable,
        validator: (value) => validateValue(textValidatorType),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          filled: true,
          fillColor: MainTheme.appColors.neutral200,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide.none,
          ),
          hintText: textHint,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
        ));
  }

  String? validateValue(String? value) {
    if (value == "emailValidator") {
      return emailValidator(textController.text);
    }  else {
      return null;
    }
  }

  //email validator
  String? emailValidator(String emailAddress) {
    if (emailAddress.isEmpty) {
      return "Field Required";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
        .hasMatch(emailAddress)) {
      return "Invalid email address";
    } else {
      return null;
    }
  }
}