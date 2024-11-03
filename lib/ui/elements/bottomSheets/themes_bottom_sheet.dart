import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/ui/elements/listItems/theme_list_item.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';

class ThemesBottomSheet extends StatelessWidget {
  const ThemesBottomSheet({super.key, required this.themeList});

  final List<ThemeModel> themeList;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.maxFinite,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              context.localized.moreThemes,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              context
                  .localized.selectAPublicHealthThemeOfInterestForFindResources,
              style: TextStyle(
                  color: MainTheme.appColors.neutral900,
                  fontWeight: FontWeight.w300,
                  fontSize: 14),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 10.0, // spacing between rows
                  crossAxisSpacing: 6.0, // spacing between columns
                ), // padding around the grid
                itemCount: themeList.length, // total number of items
                itemBuilder: (context, index) {
                  final item = themeList[index];
                  return ThemeListItem(
                    model: item,
                    color: Theme.of(context).primaryColor,
                    containerColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    onClick: () {
                      Navigator.of(context).pop();
                      context.pushNamed(themeDetail, extra: item);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
