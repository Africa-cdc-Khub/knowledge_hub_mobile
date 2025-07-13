import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/error_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/home/recommended/recommended_publication_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class RecommendedPublications extends StatefulWidget {
  const RecommendedPublications({super.key});

  @override
  State<RecommendedPublications> createState() =>
      _RecommendedPublicationsState();
}

class _RecommendedPublicationsState extends State<RecommendedPublications> {
  late RecommendedPublicationViewModel viewModel;
  late ScrollController _scrollController;

  // late Future? myFuture;
  int errorType = 2;
  String errorMessage = '';

  @override
  void initState() {
    viewModel =
        Provider.of<RecommendedPublicationViewModel>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
     _fetchItems();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      LOGGER.d("Load more here");
      // viewModel.loadMore(
      //   isFeatured: true,
      // );
      //
      // if (mounted) {
      //   setState(() {});
      // }
    }
  }

  _fetchItems() async {
    await viewModel.fetchPublications(isFeatured: true);

    if (mounted) {
      setState(() {});
    }
  }

  _likePublication(int publicationId) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.state.isLoggedIn) {
      await viewModel.addFavorite(publicationId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please login to add this publication to favorites"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendedPublicationViewModel>(
        builder: (context, provider, child) {
      if (provider.state.loading && provider.state.publications.isEmpty) {
        return const Center(child: LoadingView());
      }

      if (provider.state.errorMessage.isNotEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ErrorViewElement(
              errorType: provider.state.errorType,
              retry: () => _fetchItems(),
            ),
          ],
        );
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
        physics: const NeverScrollableScrollPhysics(),
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
            onLike: () {
              if (!item.isFavourite) {
                _likePublication(item.id);
              }
            },
            model: item,
            borderRadius: 0,
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
