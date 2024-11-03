import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class SuccessState {
  final String? type;
  final String? message;

  SuccessState({this.type, this.message});
}

class SuccessScreen extends StatelessWidget {
  final SuccessState successState;

  const SuccessScreen({super.key, required this.successState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade100,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade400,
                          size: 64,
                        ),
                      ),
                      ySpacer(24),
                      Text(
                        context.localized.success,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ySpacer(14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          successState.message ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: CustomButton(
                  containerColor: Colors.green.shade500,
                  onPressed: () {
                    if (successState.type == null) {
                      context.pop();
                    } else if (successState.type == 'register' ||
                        successState.type == 'forgotPassword') {
                      context.go('/login');
                    } else {
                      context.pop();
                    }
                  },
                  child: Text(
                    context.localized.okay,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
