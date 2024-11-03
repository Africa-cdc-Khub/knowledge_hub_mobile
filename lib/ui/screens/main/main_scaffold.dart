import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    // Provider.of<AuthViewModel>(context, listen: false).checkLoginStatus();

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 20,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: widget.navigationShell.currentIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: context.localized.home,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: const Icon(Icons.question_answer_outlined),
            activeIcon: const Icon(Icons.question_answer),
            label: context.localized.forums,
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: const IconTheme(
                data: IconThemeData(
                    size: 30, color: Colors.grey), // Increase the size here
                child: Icon(Icons.groups_outlined),
              ),
              activeIcon: IconTheme(
                data: IconThemeData(
                    size: 40,
                    color: Theme.of(context)
                        .primaryColor), // Increase the size here as well
                child: const Icon(Icons.groups),
              ),
              label: context.localized.communities),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: const Icon(Icons.book_outlined),
              activeIcon: const Icon(Icons.book),
              label: context.localized.learning),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: context.localized.settings)
        ],
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  _onTap(BuildContext context, int index) {
    // TODO a hack to check login status every time
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.checkLoginStatus();

    if (authViewModel.state.isLoggedIn) {
      Provider.of<MainViewModel>(context, listen: false)
          .getUnreadNotificationCount();
    }

    if (index == widget.navigationShell.currentIndex) {
      // If the same tab is tapped, force a reload by navigating to the initial route
      widget.navigationShell.goBranch(
        index,
        initialLocation: true, // Force reloading the current branch
      );
    } else {
      // Navigate to the new branch as usual
      widget.navigationShell.goBranch(
        index,
        initialLocation: false,
      );
    }

    // setState(() {
    //   widget.navigationShell.goBranch(
    //     index,
    //     initialLocation: index == widget.navigationShell.currentIndex,
    //   );
    // });
  }
}
