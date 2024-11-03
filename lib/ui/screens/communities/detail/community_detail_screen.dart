import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/listItems/forum_list_item.dart';
import 'package:khub_mobile/ui/elements/listItems/publication_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/screens/communities/detail/community_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/detail/forum_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_view_model.dart';

import 'dart:async';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class CommunityDetailModel {
  final int actionType;
  final int communityId;
  final String title;

  CommunityDetailModel(
      {required this.communityId,
      required this.title,
      required this.actionType});
}

class CommunityDetailScreen extends StatefulWidget {
  final CommunityDetailModel model;

  const CommunityDetailScreen({super.key, required this.model});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  // final TextEditingController _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();

  // late final Future? myFuture;
  // late SearchViewModel searchViewModel;

  // List<PublicationApiModel> items = [];
  late ScrollController _scrollController;
  late CommunityDetailViewModel communityDetailViewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    communityDetailViewModel =
        Provider.of<CommunityDetailViewModel>(context, listen: false);

    widget.model.actionType == 1 ? _fetchPublications() : _fetchForums();

    // Listen to the stream with debounce
    // _searchStreamController.stream
    //     .debounceTime(
    //         const Duration(milliseconds: 500)) // Use RxDart's debounceTime
    //     .listen((searchQuery) {
    //   widget.actionType == 1
    //       ? _fetchPublications(term: searchQuery.isNotEmpty ? searchQuery : '')
    //       : _fetchForums(term: searchQuery.isNotEmpty ? searchQuery : '');
    // });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the stream controller when done
    _searchStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  _fetchPublications() async {
    await communityDetailViewModel.fetchPublications(
        communityId: widget.model.communityId);
    setState(() {});
  }

  _fetchForums() async {
    await communityDetailViewModel.fetchForums(
        communityId: widget.model.communityId);
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.model.actionType == 1
          ? communityDetailViewModel.loadMorePublications(
              communityId: widget.model.communityId)
          : communityDetailViewModel.loadMoreForums(
              communityId: widget.model.communityId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.model.title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<CommunityDetailViewModel>(
                      builder: (context, provider, child) {
                    if (provider.state.loading) {
                      if ((widget.model.actionType == 1 &&
                              provider.state.publications.isEmpty) ||
                          (widget.model.actionType == 2 &&
                              provider.state.forums.isEmpty)) {
                        return const Center(child: LoadingView());
                      }
                    }

                    if (widget.model.actionType == 1 &&
                        provider.state.publications.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyViewElement(),
                        ],
                      );
                    }

                    if (widget.model.actionType == 2 &&
                        provider.state.forums.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyViewElement(),
                        ],
                      );
                    }

                    if (widget.model.actionType == 1) {
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
                    }
                    if (widget.model.actionType == 2) {
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
}
