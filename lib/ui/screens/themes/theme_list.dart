import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/ui/elements/bottomSheets/themes_bottom_sheet.dart';
import 'package:khub_mobile/ui/elements/listItems/theme_list_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/themes/theme_view_model.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class ThemeList extends StatefulWidget {
  const ThemeList({super.key});

  @override
  State<ThemeList> createState() => _ThemeListState();
}

class _ThemeListState extends State<ThemeList> {
  @override
  void initState() {
    // _fetchThemes();
    super.initState();
  }

  _fetchThemes() async {
    // Provider.of<ThemeViewModel>(context, listen: false).fetchThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, provider, child) {
      if (provider.state.loading && provider.state.themeList.isEmpty) {
        return const Center(child: LoadingView());
      }

      if (provider.state.themeList.isEmpty) {
        return const SizedBox.shrink();
      }

      // Get screen width and determine number of columns
      final screenSize = MediaQuery.of(context).size;
      final shortestSide = screenSize.shortestSide;
      final isTablet = shortestSide >= 600; // Material Design tablet breakpoint
      final crossAxisCount = isTablet ? 5 : 3;
      final itemWidth =
          (screenSize.width / crossAxisCount) - 12; // Account for margins

      return GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: itemWidth / (isTablet ? 120.0 : 100.0),
          crossAxisSpacing: isTablet ? 16.0 : 8.0,
          mainAxisSpacing: isTablet ? 16.0 : 8.0,
        ),
        itemCount: provider.state.actionThemeList.length,
        itemBuilder: (context, index) {
          final item = provider.state.actionThemeList[index];

          return ThemeListItem(
            model: item,
            width: itemWidth,
            height: isTablet ? 120.0 : 100.0,
            color: Theme.of(context).primaryColor,
            containerColor: Theme.of(context).primaryColor.withOpacity(0.2),
            onClick: () {
              if (item.id == 100000) {
                _showThemesBottomSheet(context, provider.state.themeList);
              } else {
                context.pushNamed(themeDetail, extra: item);
              }
            },
          );
        },
      );
    });
  }

  _showThemesBottomSheet(BuildContext context, List<ThemeModel> themeList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85, // Start just below the AppBar
          minChildSize: 0.5, // Minimum height (half screen)
          maxChildSize: 0.85, // Maximum height (90% of screen)
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ThemesBottomSheet(
                themeList: themeList,
              ),
            );
          },
        );

        // return DraggableScrollableSheet(
        //   initialChildSize: 0.9, // Start just below the AppBar
        //   minChildSize: 0.5, // Minimum height (half screen)
        //   maxChildSize: 0.9, // Maximum height (90% of screen)
        //   expand: false,
        //   builder: (_, scrollController) {
        //     return SingleChildScrollView(
        //       controller: scrollController,
        // child: ThemesBottomSheet(
        //   themeList: themeList,
        // ),
        //     );
        //   },
        // );
      },
    );
  }
}
