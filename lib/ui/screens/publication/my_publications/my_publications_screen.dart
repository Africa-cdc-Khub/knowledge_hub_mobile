import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/not_logged_in_view.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/my_publications/my_publications_view_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class MyPublicationsScreen extends StatefulWidget {
  const MyPublicationsScreen({super.key});

  @override
  State<MyPublicationsScreen> createState() => _MyPublicationsScreenState();
}

class _MyPublicationsScreenState extends State<MyPublicationsScreen> {
  late ScrollController _scrollController;
  late MyPublicationsViewModel viewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    viewModel = Provider.of<MyPublicationsViewModel>(context, listen: false);
    _fetchPublications();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      viewModel.loadMore();

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchPublications() async {
    await viewModel.fetchPublications();
    if (mounted) {
      setState(() {});
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
          title: appBarText(context, context.localized.myPublications),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MainTheme.appColors.neutralBg,
            padding: const EdgeInsets.all(0),
            child: Consumer<AuthViewModel>(builder: (context, provider, child) {
              if (!provider.state.isLoggedIn) {
                return NotLoggedInView(
                  title: context
                      .localized.youNeedToBeLoggedInToViewYourPublications,
                );
              }

              return _myPublicationsContent();
            })));
  }

  Widget _myPublicationsContent() {
    return Consumer<MyPublicationsViewModel>(
        builder: (context, provider, child) {
      if (provider.state.loading && provider.state.publications.isEmpty) {
        return const Center(child: LoadingView());
      }

      if (provider.state.publications.isEmpty) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyViewElement(),
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
            return const Center(child: LoadingView());
          }

          return PublicationItem(
            isVerticalItem: true,
            isMyPublication: true,
            borderRadius: 0,
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
