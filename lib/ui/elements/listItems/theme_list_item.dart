import 'package:flutter/material.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/utils/fontawesome_utils.dart';

class ThemeListItem extends StatelessWidget {
  final ThemeModel model;
  final Color? containerColor;
  final Color? color;
  final double width;
  final double height;
  final Null Function()? onClick;

  const ThemeListItem({
    super.key,
    this.containerColor,
    this.color,
    this.onClick,
    required this.model,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = iconClassToIcon[model.icon];
    final double itemWidth = width;
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final bool showDescription = itemWidth >= 100;

    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: itemWidth,
        height: height,
        child: Card(
          elevation: 0,
          color: containerColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 24.0 : 18.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 10.0 : 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  model.id == 100000
                      ? Icons.dashboard_customize_rounded
                      : iconData,
                  size: isTablet ? 32 : 25,
                  color: color ?? Colors.white,
                ),
                if (showDescription)
                  Padding(
                    padding: EdgeInsets.only(top: isTablet ? 12.0 : 8.0),
                    child: Text(
                      model.description,
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: isTablet ? 14 : 12,
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
