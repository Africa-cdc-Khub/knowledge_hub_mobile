import 'package:flutter/material.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/community_list_items.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/communities/communities_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  late ScrollController _scrollController;
  late CommunitiesViewModel communitiesViewModel;

  List<CommunityModel> items = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    communitiesViewModel =
        Provider.of<CommunitiesViewModel>(context, listen: false);
    _fetchItems();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      communitiesViewModel.loadMore();

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchItems() async {
    await communitiesViewModel.fetchCommunities();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: appBarText(context, context.localized.communities)),
      body: Container(
        padding: const EdgeInsets.all(0.0),
        color: MainTheme.appColors.white300,
        child: Column(
          children: [
            Expanded(
              child: Consumer<CommunitiesViewModel>(
                  builder: (context, provider, child) {
                if (provider.state.loading &&
                    provider.state.communities.isEmpty) {
                  return const Center(child: LoadingView());
                }

                if (provider.state.communities.isEmpty) {
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
                  itemCount: provider.state.communities.length +
                      (provider.state.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    final item = provider.state.communities[index];

                    if (index == provider.state.communities.length) {
                      return provider.state.loading
                          ? const Center(child: LoadingView())
                          : const SizedBox.shrink();
                    }

                    return CommunityListItem(
                        // borderRadius: 0,
                        community: item,
                        onClick: () {
                          // Provider.of<ForumDetailViewModel>(context,
                          //         listen: false)
                          //     .setCurrentForum(item);
                          // context.pushNamed(forumDetail, extra: item);
                        });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
