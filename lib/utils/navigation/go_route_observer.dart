import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouteObserver extends NavigatorObserver {
  final void Function(BuildContext) onForumsRefresh;

  GoRouteObserver({required this.onForumsRefresh});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings is Page) {
      final state = (route.settings as Page).arguments;
      if (state is GoRouterState) {
        final extra = state.extra;
        if (extra is Map && extra['refresh'] == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (navigator?.context != null) {
              onForumsRefresh(navigator!.context);
            }
          });
        }
      }
    }
    super.didPush(route, previousRoute);
  }
}
