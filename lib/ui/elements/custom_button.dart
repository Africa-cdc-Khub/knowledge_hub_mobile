import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.containerColor,
      this.width,
      this.foregroundColor,
      this.loading,
      this.loadingText});

  final Widget child;
  final VoidCallback onPressed;
  final Color? containerColor;
  final Color? foregroundColor;
  final double? width;
  final bool? loading;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: width ?? double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  containerColor ?? Theme.of(context).primaryColor),
              overlayColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor.withOpacity(0.1)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ))),
          onPressed: loading != null && loading! == true ? null : onPressed,
          child: _content(child, context)),
    );
  }

  Widget _content(Widget child, BuildContext context) {
    if (loading != null && loading! == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: MainTheme.appColors.white200,
              strokeWidth: 3.0,
            ),
          ),
          xSpacer(16),
          Text(
            loadingText ?? context.localized.pleaseWait,
            style: TextStyle(
              fontSize: 14,
              color: MainTheme.appColors.white200,
            ),
          )
        ],
      );
    }

    return child;
  }
}
