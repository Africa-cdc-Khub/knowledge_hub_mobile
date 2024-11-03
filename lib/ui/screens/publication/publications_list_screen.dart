import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/publication_list_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class PublicationListScreenState {
  int listType; // 1. Recommended, 2. Top Searches, 3. Category
  int? categoryId;
  String title;

  PublicationListScreenState(
      {required this.listType, this.categoryId, required this.title});
}

class PublicationsListScreen extends StatefulWidget {
  final PublicationListScreenState state;

  const PublicationsListScreen({super.key, required this.state});

  @override
  State<PublicationsListScreen> createState() => _PublicationsListScreenState();
}

class _PublicationsListScreenState extends State<PublicationsListScreen> {
  late ScrollController _scrollController;
  late PublicationListViewModel viewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    viewModel = Provider.of<PublicationListViewModel>(context, listen: false);
    _fetchPublications();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      viewModel.loadMore(
        isFeatured: widget.state.listType == 1 ? true : null,
        orderByVisits: widget.state.listType == 2 ? true : null,
        categoryId: widget.state.categoryId,
      );

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchPublications() async {
    await viewModel.fetchPublications(
      isFeatured: widget.state.listType == 1 ? true : null,
      orderByVisits: widget.state.listType == 2 ? true : null,
      categoryId: widget.state.categoryId,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.state.title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final authViewModel =
                Provider.of<AuthViewModel>(context, listen: false);
            if (authViewModel.state.isLoggedIn) {
              context.pushNamed(publish);
            } else {
              context.pushNamed(login);
            }
          },
          tooltip: context.localized.newPublication,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          heroTag: 'uniqueTag',
          elevation: 6.0,
          child: const Icon(Icons.add),
        ),
        body: Container(
            padding: const EdgeInsets.all(0),
            child: Consumer<PublicationListViewModel>(
                builder: (context, provider, child) {
              if (provider.state.loading &&
                  provider.state.publications.isEmpty) {
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
                    return provider.state.loading
                        ? const Center(child: LoadingView())
                        : const SizedBox.shrink();
                  }

                  return PublicationItem(
                    isVerticalItem: true,
                    borderRadius: 0,
                    model: item,
                    onClick: () {
                      Provider.of<PublicationDetailViewModel>(context,
                              listen: false)
                          .setCurrentPublication(item);
                      context.pushNamed(publicationDetail, extra: item);
                    },
                  );
                },
              );
            })));
  }
}
