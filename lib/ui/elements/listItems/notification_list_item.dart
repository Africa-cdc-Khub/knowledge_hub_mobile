import 'package:flutter/material.dart';
import 'package:khub_mobile/models/notification_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListItem extends StatelessWidget {
  final NotificationModel model;
  final VoidCallback? onClick;

  const NotificationListItem({super.key, required this.model, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    ySpacer(4),
                    Text(model.message, softWrap: true),
                    ySpacer(4),
                    Text(
                      timeago.format(Helpers.parseDate(model.createdAt)),
                      style: TextStyle(
                          color: MainTheme.appColors.neutral600, fontSize: 10),
                    )
                  ],
                ),
              ),
              (!model.read)
                  ? Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: MainTheme.appColors.orange500,
                          borderRadius: BorderRadius.circular(50)),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
