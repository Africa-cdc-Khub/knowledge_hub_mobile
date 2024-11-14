import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';

class SocialLoginButtons extends StatelessWidget {
  final Function() onGoogleSignIn;
  final Function() onMicrosoftSignIn;
  const SocialLoginButtons(
      {super.key,
      required this.onGoogleSignIn,
      required this.onMicrosoftSignIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
              ),
            ],
          ),
          ySpacer(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                    containerColor: MainTheme.appColors.white200,
                    foregroundColor: Colors.black,
                    onPressed: onGoogleSignIn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',
                            height: 24),
                        const SizedBox(width: 8),
                        const Text('Google',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomButton(
                    onPressed: onMicrosoftSignIn,
                    containerColor: MainTheme.appColors.white200,
                    foregroundColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/microsoft_icon.png',
                            height: 24),
                        const SizedBox(width: 8),
                        const Text('Microsoft',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
