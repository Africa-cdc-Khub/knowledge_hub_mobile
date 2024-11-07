import 'package:flutter/material.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class ErrorViewElement extends StatelessWidget {
  final String? message;
  final int? errorType; // 1: No internet connection, 2: Remote error
  final VoidCallback? retry;

  const ErrorViewElement({super.key, this.message, this.errorType, this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(_errorIcon(errorType), size: 30, color: Colors.grey),
            ySpacer(8.0),
            Text(_errorMessage(context, message, errorType),
                style: const TextStyle(color: Colors.grey)),
            retry != null
                ? TextButton(
                    onPressed: retry,
                    child: Text(
                      context.localized.retry,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  IconData _errorIcon(int? errorType) {
    if (errorType != null && errorType == 1) {
      return Icons.wifi_off;
    } else {
      return Icons.cloud_off;
    }
  }

  String _errorMessage(BuildContext context, String? message, int? errorType) {
    if (errorType != null && errorType == 1) {
      return context.localized.noInternetConnection;
    } else {
      return message ?? context.localized.noRecordsFound;
    }
  }
}
