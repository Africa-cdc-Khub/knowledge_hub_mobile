import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/custom_button.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/themes/detail/theme_detail_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class ThemeDetailScreen extends StatefulWidget {
  final ThemeModel theme;

  const ThemeDetailScreen({super.key, required this.theme});

  @override
  State<ThemeDetailScreen> createState() => _ThemeDetailScreenState();
}

class _ThemeDetailScreenState extends State<ThemeDetailScreen> {
  late ScrollController _scrollController;
  late ThemeDetailViewModel viewModel;
  int? _selectedSubThemeId;
  // final bool _emptySubThemes = false;

  @override
  void initState() {
    viewModel = Provider.of<ThemeDetailViewModel>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _fetchItems();
    super.initState();
  }

  void _fetchItems() async {
    int themeId = widget.theme.id;

    // Fetch theme publications
    _fetchThemPublications(themeId);

    // Fetch theme sub themes
    _fetchSubThemes(themeId);
  }

  void _fetchThemPublications(int themeId) {
    viewModel.fetchPublications(
        themeId: themeId, subThemeId: _selectedSubThemeId);
  }

  void _fetchSubThemes(int themeId) {
    viewModel.fetchSubThemes(themeId: themeId);
  }

  void _onSubThemeSelected(int subThemeId) {
    LOGGER.d(subThemeId);
    setState(() {
      _selectedSubThemeId = subThemeId;
    });

    // Fetch publications for the selected sub-theme
    _fetchThemPublications(widget.theme.id);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      int themeId = widget.theme.id;
      viewModel.loadMore(themeId: themeId, subThemeId: _selectedSubThemeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(context, widget.theme.description),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MainTheme.appColors.neutralBg,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ThemeDetailViewModel>(
                  builder: (context, provider, child) {
                if (provider.state.subThemes.isNotEmpty) {
                  return Text(
                    context.localized.subThemes,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  );
                }
                return const SizedBox.shrink();
              }),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 16),
                child: Container(
                    constraints: const BoxConstraints(
                        minHeight: 40, minWidth: 50, maxHeight: 80),
                    child: _subThemes()),
              ),
              Text(
                context.localized.publications,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: _themePublications()))
            ],
          )),
    );
  }

  Widget _subThemes() {
    return Consumer<ThemeDetailViewModel>(builder: (context, provider, child) {
      if (provider.state.loadingSubThemes) {
        return const Center(child: LoadingView());
      }

      if (provider.state.subThemes.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.state.subThemes.length,
        itemBuilder: (context, index) {
          final item = provider.state.subThemes[index];
          final isSelected = _selectedSubThemeId == item.id;

          return InkWell(
            onTap: () => _onSubThemeSelected(item.id),
            child: SizedBox(
              width: 150,
              child: Card(
                elevation: 0,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    item.description,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _themePublications() {
    return Consumer<ThemeDetailViewModel>(builder: (context, provider, child) {
      if (provider.state.loading) {
        return const Center(child: LoadingView());
      }

      if (provider.state.publications.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyViewElement(),
            ySpacer(8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: CustomButton(
                onPressed: () {
                  context.pushNamed(contentRequest);
                },
                child: Text(
                  context.localized.requestContent,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.state.publications.length +
            (provider.state.loading ? 1 : 0),
        itemBuilder: (context, index) {
          final item = provider.state.publications[index];

          if (index == provider.state.publications.length) {
            return provider.state.loading
                ? const Center(child: LoadingView())
                : const SizedBox.shrink();
          }

          return PublicationItem(
            isVerticalItem: true,
            model: item,
            onClick: () {
              Provider.of<PublicationDetailViewModel>(context, listen: false)
                  .setCurrentPublication(item);
              context.pushNamed(publicationDetail, extra: item);
            },
          );
        },
      );
    });
  }
}
