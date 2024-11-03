import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class AlertUtils {

  static showError({required BuildContext context, required String errorMessage, String? title}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: title ?? 'Error',
      desc: errorMessage,
        btnCancelColor: MainTheme.appColors.red400,
      btnOkColor: MainTheme.appColors.red400,
        keyboardAware: false,
        headerAnimationLoop: false,
      transitionAnimationDuration: const Duration(milliseconds: 0),
      btnOkOnPress: () {
      },
    ).show();
    // Flushbar(
    //   title:  title ?? 'Error',
    //   message:  errorMessage,
    //   duration:  const Duration(seconds: 3),
    // ).show(context);
  }
}