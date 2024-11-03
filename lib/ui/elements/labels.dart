import 'package:flutter/material.dart';

Widget homeLabel(BuildContext context, {required String title, String? description, String? actionLabel, Null Function()? onClick}) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: const TextStyle(
                    fontSize: 17.0
                ),
              ),
              description != null ? Text(description,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400
                ),
              ) : const SizedBox.shrink()
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (onClick != null) {
              onClick();
            }
          },
          child: actionLabel != null ? Text(actionLabel,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600
            ),
          ) : const SizedBox.shrink(),
        )
      ],
    )
  );
}

Widget editTextLabel(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Text(title,
      textAlign: TextAlign.start,
      style:  TextStyle(fontSize: 14, color: Colors.grey.shade700),
    ),
  );
}