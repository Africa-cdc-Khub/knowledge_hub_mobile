import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';

class NotLoggedInBanner extends StatelessWidget {
  final Color? contentColor;

  const NotLoggedInBanner({super.key, this.contentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localized.youAreNotLoggedIn,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                      maxLines: null,
                      softWrap: true,
                    ),
                    Text(
                      context.localized.pleaseLoginToAccessMoreFeatures,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: contentColor ?? Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      maxLines: null,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (() {
                  context.pushNamed(login);
                }),
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        contentColor ?? Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ))),
                child: Text(context.localized.loginNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
