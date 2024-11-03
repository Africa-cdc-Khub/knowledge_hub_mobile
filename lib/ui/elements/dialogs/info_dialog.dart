import 'package:flutter/material.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String content;
  final String? confirmText;
  final Color? confirmTextColor;
  final Color? confirmBackgroundColor;
  final String? cancelText;
  final Color? cancelTextColor;
  final Color? titleBackgroundColor;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool? isLoading;

  const InfoDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    this.confirmText = 'Confirm',
    this.confirmTextColor,
    this.confirmBackgroundColor,
    this.cancelText = 'Cancel',
    this.cancelTextColor,
    this.isLoading,
    this.titleBackgroundColor,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: titleBackgroundColor ?? Theme.of(context).primaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon != null
                    ? Icon(icon, color: Colors.white, size: 24)
                    : const SizedBox.shrink(),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ButtonBar(
            buttonPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text(cancelText ?? context.localized.cancel,
                    style: TextStyle(
                      color: cancelTextColor ?? Theme.of(context).primaryColor,
                    )),
              ),
              ElevatedButton(
                onPressed: isLoading != null && isLoading! ? null : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      confirmBackgroundColor ?? Theme.of(context).primaryColor,
                  foregroundColor: confirmTextColor ?? Colors.white,
                ),
                child: isLoading != null && isLoading!
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: confirmBackgroundColor ??
                              Theme.of(context).primaryColor,
                        ),
                      )
                    : Text(confirmText ?? context.localized.confirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
