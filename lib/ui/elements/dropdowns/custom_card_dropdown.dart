import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class CustomCardDropdown extends StatelessWidget {
  final Function() onTap;
  final String value;
  final Color? containerColor;
  const CustomCardDropdown(
      {super.key,
      required this.onTap,
      required this.value,
      this.containerColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0,
          color: containerColor ?? MainTheme.appColors.white200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    size: 24, color: Colors.black54)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
