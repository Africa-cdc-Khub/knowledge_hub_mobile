import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';

class NotificationIconCount extends StatelessWidget {
  final IconData icon;
  final int notificationCount;
  final double size;

  const NotificationIconCount({
    super.key,
    required this.icon,
    required this.notificationCount,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          size: size,
        ),
        if (notificationCount > 0)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: MainTheme.appColors.red400,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}