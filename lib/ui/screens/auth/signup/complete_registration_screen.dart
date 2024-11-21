import 'package:flutter/material.dart';
import 'package:khub_mobile/ui/screens/auth/signup/signup_screen.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class CompleteRegistrationScreenState {
  final bool? isSocialSignup;
  final Map<String, dynamic>? socialSignupData;

  CompleteRegistrationScreenState({this.isSocialSignup, this.socialSignupData});
}

class CompleteRegistrationScreen extends StatelessWidget {
  final CompleteRegistrationScreenState? completeRegistrationState;
  const CompleteRegistrationScreen({super.key, this.completeRegistrationState});

  @override
  Widget build(BuildContext context) {
    return SignUpScreen(
      signupState: SignupScreenState(
        title: context.localized.completeRegistration,
        isSocialSignup: completeRegistrationState?.isSocialSignup,
        socialSignupData: completeRegistrationState?.socialSignupData,
      ),
    );
  }
}
