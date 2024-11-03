import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/ui/screens/auth/forgotPassword/forgot_password_view_model.dart';
import 'package:khub_mobile/ui/screens/success/success_screen.dart';
import 'package:khub_mobile/utils/alert_utils.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:khub_mobile/utils/validator.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  late ForgotPasswordViewModel viewModel;
  bool _loading = false;

  @override
  void initState() {
    viewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(children: [
          SingleChildScrollView(
            child: Form(
              key: _forgotPasswordFormKey,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ySpacer(60),
                        Image.asset(
                          'assets/images/africa_cdc.png',
                          width: 200.0,
                          height: 90.0,
                        ),
                        ySpacer(50),
                        Text(context.localized.forgotPassword,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 32)),
                        ySpacer(24),
                        Text(
                          context.localized
                              .enterTheEmailAddressAssociatedWithYourAccount,
                          style: const TextStyle(fontSize: 16),
                        ),
                        ySpacer(16),
                        editTextLabel(context.localized.email),
                        EditTextField(
                          containerColor: MainTheme.appColors.white200,
                          textHint: context.localized.enterEmailAddress,
                          textController: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return Validator.validateEmail(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  ySpacer(50),
                  CustomButton(
                    width: double.infinity,
                    loading: _loading,
                    onPressed: () {
                      if (_forgotPasswordFormKey.currentState?.validate() ??
                          false) {
                        _sendResetLink();
                      }
                    },
                    child: Text(
                      context.localized.sendResetLink,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  void _sendResetLink() async {
    setState(() {
      _loading = true;
    });

    final state = await viewModel.forgotPassword(_emailController.text);

    if (!state.isSuccess && mounted) {
      setState(() {
        _loading = false;
      });
      AlertUtils.showError(context: context, errorMessage: state.errorMessage);
    } else {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        context.pushNamed(success,
            extra: SuccessState(
                type: 'forgotPassword',
                message:
                    context.localized.weHaveSentYouALinkToResetYourPassword));
      }
    }
  }
}
