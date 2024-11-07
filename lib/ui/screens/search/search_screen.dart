import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/elements/error_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/forum_list_item.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/ai/compare/compare_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/detail/forum_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/ui/elements/textFields/edit_text_field.dart';
import 'package:khub_mobile/models/search_type_enum.dart';
import 'package:khub_mobile/ui/screens/search/search_view_model.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class SearchScreenState {
  final int target; // 1: search, 2: compare
  final SearchType searchType;

  SearchScreenState({required this.target, required this.searchType});
}

class SearchScreen extends StatefulWidget {
  final SearchScreenState searchState;

  const SearchScreen({super.key, required this.searchState});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();

  // late final Future? myFuture;
  // late SearchViewModel searchViewModel;

  // List<PublicationApiModel> items = [];
  late ScrollController _scrollController;
  late SearchViewModel searchViewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    searchViewModel = Provider.of<SearchViewModel>(context, listen: false);

    widget.searchState.searchType == SearchType.publication
        ? _fetchPublications()
        : _fetchForums();

    // Listen to the stream with debounce
    _searchStreamController.stream
        .debounceTime(
            const Duration(milliseconds: 500)) // Use RxDart's debounceTime
        .listen((searchQuery) {
      widget.searchState.searchType == SearchType.publication
          ? _fetchPublications(term: searchQuery.isNotEmpty ? searchQuery : '')
          : _fetchForums(term: searchQuery.isNotEmpty ? searchQuery : '');
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the stream controller when done
    _searchStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  _fetchPublications({String? term}) async {
    await searchViewModel.fetchPublications(term: term ?? '');
    setState(() {});
  }

  _fetchForums({String? term}) async {
    await searchViewModel.fetchForums(term: term ?? '');
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.searchState.searchType == SearchType.publication
          ? searchViewModel.loadMorePublications()
          : searchViewModel.loadMoreForums();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.searchState.searchType == SearchType.publication
                ? context.localized.searchPublication
                : context.localized.searchForum,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                EditTextField(
                  textHint: context.localized.search,
                  textController: _searchController,
                  borderRadius: 0,
                  onChanged: (value) {
                    if (value != null) {
                      _searchStreamController
                          .add(value); // Add value to the stream
                    }
                  },
                ),
                ySpacer(6),
                Expanded(
                  child: Consumer<SearchViewModel>(
                      builder: (context, provider, child) {
                    if (provider.state.loading) {
                      if ((widget.searchState.searchType ==
                                  SearchType.publication &&
                              provider.state.publications.isEmpty) ||
                          (widget.searchState.searchType == SearchType.forum &&
                              provider.state.forums.isEmpty)) {
                        return const Center(child: LoadingView());
                      }
                    }

                    if (provider.state.errorMessage.isNotEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ErrorViewElement(
                            errorType: provider.state.errorType,
                            retry: () => widget.searchState.searchType ==
                                    SearchType.publication
                                ? _fetchPublications()
                                : _fetchForums(),
                          ),
                        ],
                      );
                    }

                    if (widget.searchState.searchType ==
                            SearchType.publication &&
                        provider.state.publications.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyViewElement(),
                        ],
                      );
                    }

                    if (widget.searchState.searchType == SearchType.forum &&
                        provider.state.forums.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyViewElement(),
                        ],
                      );
                    }

                    if (widget.searchState.searchType ==
                        SearchType.publication) {
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
                              _onPublicationClick(item);
                            },
                          );
                        },
                      );
                    }
                    if (widget.searchState.searchType == SearchType.forum) {
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.state.forums.length +
                            (provider.state.loading ? 1 : 0),
                        itemBuilder: (context, index) {
                          final item = provider.state.forums[index];

                          if (index == provider.state.forums.length) {
                            return provider.state.loading
                                ? const Center(child: LoadingView())
                                : const SizedBox.shrink();
                          }

                          return ForumListItem(
                            borderRadius: 0,
                            model: item,
                            onClick: () {
                              Provider.of<ForumDetailViewModel>(context,
                                      listen: false)
                                  .setCurrentForum(item);
                              context.pushNamed(forumDetail, extra: item);
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                )
              ],
            )));
  }

  void _onPublicationClick(PublicationModel item) {
    if (widget.searchState.target == 1) {
      Provider.of<PublicationDetailViewModel>(context, listen: false)
          .setCurrentPublication(item);
      context.pushNamed(publicationDetail, extra: item);
    } else if (widget.searchState.target == 2) {
      Provider.of<CompareViewModel>(context, listen: false)
          .setPublicationTwo(item);
      context.pushNamed(aiComparePublications, extra: item);
    }
  }
}
