import 'package:flutter/material.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/utils/fontawesome_utils.dart';

class ThemeListItem extends StatelessWidget {
  final ThemeModel model;
  final Color? containerColor;
  final Color? color;
  final double? width;
  final double? height;
  final Null Function()? onClick;

  const ThemeListItem({
    super.key,
    this.containerColor,
    this.color,
    this.onClick,
    required this.model,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = iconClassToIcon[model.icon];
    final double itemWidth = width ?? 100;
    final bool showDescription = itemWidth >= 100;

    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: itemWidth,
        height: height ?? (showDescription ? 80.0 : 64.0),
        child: Card(
          elevation: 0,
          color: containerColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  model.id == 100000
                      ? Icons.dashboard_customize_rounded
                      : iconData,
                  size: 25,
                  color: color ?? Colors.white,
                ),
                if (showDescription)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      model.description ?? '',
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
