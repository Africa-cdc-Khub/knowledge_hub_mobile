import 'package:flutter/material.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class EmptyViewElement extends StatelessWidget {
  final String? message;
  final IconData? icon;
  const EmptyViewElement({super.key, this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon ?? Icons.article, color: Colors.grey),
            ySpacer(8.0),
            Text(message ?? context.localized.noRecordsFound,
                style: const TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
