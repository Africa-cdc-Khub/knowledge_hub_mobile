import 'package:flutter/material.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/not_logged_in_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/stepper_widget.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/publish/publish_four_screen.dart';
import 'package:khub_mobile/ui/screens/publish/publish_one_screen.dart';
import 'package:khub_mobile/ui/screens/publish/publish_three_screen.dart';
import 'package:khub_mobile/ui/screens/publish/publish_two_screen.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class CreatePublicationScreen extends StatefulWidget {
  const CreatePublicationScreen({super.key});

  @override
  State<CreatePublicationScreen> createState() =>
      _CreatePublicationScreenState();
}

class _CreatePublicationScreenState extends State<CreatePublicationScreen> {
  int _currentStep = 0;
  bool _isLoggedIn = false;
  late PublishViewModel viewModel;
  late AuthViewModel authViewModel;
  late MainViewModel mainViewModel;

  late Key _stepContentKey;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    _checkLoginStatus();
    _getUtilities();
    _init();
    // Initialize the key
    _stepContentKey = ValueKey(_currentStep);
  }

  Future<void> _getUtilities() async {
    await mainViewModel.syncUtilities();
    setState(() {});
  }

  Future<void> _checkLoginStatus() async {
    final status = await authViewModel.checkLoginStatus();
    setState(() {
      _isLoggedIn = status;
    }); // Trigger a rebuild after login status is checked
  }

  void _init() {
    viewModel.fetchThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBarText(context, context.localized.createPublication),
      ),
      body: Container(
          width: double.infinity,
          color: MainTheme.appColors.white200,
          // child: _isLoggedIn
          //     ? _publicationContent()
          //     : const NotLoggedInView(
          //         title:
          //             'You need to be logged in for you to create a new publication.',
          //       ),

          child: Consumer<AuthViewModel>(builder: (context, provider, child) {
            // if (provider.state.loading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (!provider.state.isLoggedIn) {
              return NotLoggedInView(
                title: context
                    .localized.youNeedToBeLoggedInForYouToCreateANewPublication,
              );
            }

            if (provider.state.isLoggedIn) {
              return _publicationContent();
            }

            return const SizedBox.shrink();
          })),
    );
  }

  Widget _publicationContent() {
    return Column(
      children: [
        ySpacer(20),
        _steppers(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StepContent(
              key: _stepContentKey,
              step: _currentStep,
              onBack: () {
                setState(() {
                  _currentStep -= 1;
                  _stepContentKey = ValueKey(_currentStep);
                });
              },
              onCompleteStep: ({step}) {
                setState(() {
                  _currentStep += 1;
                  _stepContentKey = ValueKey(_currentStep);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _steppers() {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = math.min(constraints.maxWidth, 800.0);

      return Center(
        child: SizedBox(
          width: maxWidth,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              // Calculate connector width based on available space
              final itemWidth = maxWidth / 4;
              final connectorWidth =
                  itemWidth - 70; // Subtract space for step circle

              return Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {},
                        child: StepWidget(
                          isActive: index == _currentStep,
                          isCompleted: index < _currentStep,
                          stepNumber: index + 1,
                          title: '${context.localized.step} ${index + 1}',
                        ),
                      ),
                    ),
                    if (index != 3)
                      Positioned(
                        left: itemWidth / 2 + 12,
                        right: 0,
                        top: 16,
                        child: Connector(
                          isActive: index < _currentStep,
                        ),
                      ),
                    if (index != 0)
                      Positioned(
                        left: 0,
                        right: itemWidth / 2 + 10,
                        top: 16,
                        child: Connector(
                          isActive: index < _currentStep + 1,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

class StepContent extends StatelessWidget {
  final int step;
  final Function() onBack;
  final Function({int? step}) onCompleteStep;

  const StepContent(
      {super.key,
      required this.step,
      required this.onBack,
      required this.onCompleteStep});

  @override
  Widget build(BuildContext context) {
    if (step == 0) {
      return PublishOneScreen(onNext: () {
        onCompleteStep();
      });
    }

    if (step == 1) {
      return PublishTwoScreen(
        onNext: () {
          onCompleteStep();
        },
        onBack: () {
          onBack();
        },
      );
    }

    if (step == 2) {
      return PublishThreeScreen(
        onNext: () {
          onCompleteStep();
        },
        onBack: () {
          onBack();
        },
      );
    }

    if (step == 3) {
      return PublishFourScreen(
        onBack: () {
          onBack();
        },
      );
    }

    return const SizedBox.shrink();
  }
}
