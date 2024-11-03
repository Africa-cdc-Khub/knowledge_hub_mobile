import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';

class NotLoggedInView extends StatelessWidget {
  final String? title;

  const NotLoggedInView({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final defaultTitle = context.localized.youNeedToLoginToViewThisContent;
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.user,
              color: Theme.of(context).primaryColor, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Text(
              context.localized.notLoggedIn,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
            child: Text(
              title ?? defaultTitle,
              style: const TextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
                child: Text(context.localized.loginNow,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white)),
                onPressed: () {
                  context.pushNamed(login);
                }),
          ),
        ],
      ),
    );
  }
}
