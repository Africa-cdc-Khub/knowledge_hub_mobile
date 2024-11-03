import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/date_input_formatters.dart';
import 'package:intl/intl.dart';

class DOBEditText extends StatelessWidget {
  const DOBEditText({
    super.key,
    required this.textLabel,
    required this.textHint,
    required this.textController,
    required this.textValidatorType,
  });

  final String textLabel;
  final String textHint;
  final String? textValidatorType; //validator types: email, password
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          DateInputFormatter(),
        ],
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
          label: Text(
            textLabel,
            style: TextStyle(
                color: MainTheme.appColors.neutral900,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ));
  }

  String? validateValue(String? value) {
    if(value == "dobValidator"){
      return birthDateValidator(textController.text);
    }
    else {
      return null;
    }
  }

  //date of birth validator
  String? birthDateValidator(String value){
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    final String formatted = formatter.format(now);
    String str1 = value;
    List<String> str2 = str1.split('/');
    String day = str2.isNotEmpty ? str2[0] : '';
    String month = str2.length > 1 ? str2[1] :'';
    String year = str2.length > 2 ? str2[2] : '';
    if(value.isEmpty){
      return 'Value required';
    }
    else if(int.parse(month) > 13){
      return 'Invalid month';
    }
    else if(int.parse(day) > 32){
      return 'Invalid day';
    }
    else if(int.parse(year) > int.parse(formatted)){
      return 'Invalid Year';
    }
    else if(int.parse(year) < 1940){
      return 'Invalid year';
    }
    else if((int.parse(formatted) - int.parse(year))  < 18){
      return 'Age provided is below 18yrs.';
    }
    return null;
  }

}