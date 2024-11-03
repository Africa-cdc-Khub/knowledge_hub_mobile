import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/ui/elements/empty_view_element.dart';
import 'package:khub_mobile/ui/elements/listItems/notification_list_item.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/notifications/notifications_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late ScrollController _scrollController;
  late NotificationsViewModel notificationsViewModel;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    notificationsViewModel =
        Provider.of<NotificationsViewModel>(context, listen: false);
    _fetchItems();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      notificationsViewModel.loadMore();

      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchItems() async {
    await notificationsViewModel.fetchNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(
          context,
          context.localized.notifications,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MainTheme.appColors.neutralBg,
        padding: const EdgeInsets.all(10),
        child: Consumer<NotificationsViewModel>(
            builder: (context, provider, child) {
          if (provider.state.loading && provider.state.notifications.isEmpty) {
            return const Center(child: LoadingView());
          }

          if (provider.state.notifications.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyViewElement(
                    icon: Icons.notifications,
                    message: context.localized.noNotificationsFound),
              ],
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.localized.allNotifications,
                      style: const TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      _markAllAsRead();
                    },
                    child: Text(context.localized.markAllAsRead,
                        style: const TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.state.notifications.length +
                      (provider.state.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    final item = provider.state.notifications[index];

                    if (index == provider.state.notifications.length) {
                      return provider.state.loading
                          ? const Center(child: LoadingView())
                          : const SizedBox.shrink();
                    }

                    return NotificationListItem(
                      model: item,
                      onClick: () {},
                    );
                  },
                ),
              ),
            ],
          );
        }),

        // FutureBuilder(
        //     future: myFuture,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return ListView.builder(
        //           shrinkWrap: true,
        //           itemCount: items.length,
        //           itemBuilder: (context, index) {
        //             final item = items[index];
        // return NotificationListItem(
        //   model: item,
        //   onClick: () {},
        // );
        //           },
        //         );
        //       } else {
        //         return const SizedBox.shrink();
        //       }
        //     }),
      ),
    );
  }

  _markAllAsRead() async {
    final result = await notificationsViewModel.markAllNotificationsAsRead();

    if (result && mounted) {
      Provider.of<MainViewModel>(context, listen: false)
          .getUnreadNotificationCount();
    }
  }
}
