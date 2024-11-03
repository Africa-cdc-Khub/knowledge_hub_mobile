import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/forum_list_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/search_bar.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/search_type_enum.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/detail/forum_detail_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

import 'forums_view_model.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  late ScrollController _scrollController;
  late ForumsViewModel forumsViewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    forumsViewModel = Provider.of<ForumsViewModel>(context, listen: false);
    _fetchItems();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      forumsViewModel.loadMore();

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchItems() async {
    await forumsViewModel.fetchForums();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarText(context, "Forums")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final authViewModel =
              Provider.of<AuthViewModel>(context, listen: false);
          if (authViewModel.state.isLoggedIn) {
            context.pushNamed(createForum);
          } else {
            context.pushNamed(login);
          }
        },
        tooltip: context.localized.newDiscussion,
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
        padding: const EdgeInsets.all(0.0),
        color: MainTheme.appColors.white300,
        child: Column(
          children: [
            const AppSearchBar(searchType: SearchType.forum),
            ySpacer(1),
            Expanded(
              child: Consumer<ForumsViewModel>(
                  builder: (context, provider, child) {
                if (provider.state.loading && provider.state.forums.isEmpty) {
                  return const Center(child: LoadingView());
                }

                if (provider.state.forums.isEmpty) {
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}
