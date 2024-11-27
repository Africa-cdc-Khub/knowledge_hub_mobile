import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/main.dart';
import 'package:khub_mobile/ui/elements/dialogs/info_dialog.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/account/profile/profile_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/viewer/web_viewer.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AuthViewModel authViewModel;
  late ProfileViewModel profileViewModel;

  @override
  void initState() {
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    await profileViewModel.getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          context.localized.settings,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: MainTheme.appColors.white600,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _accountItem(context,
                    routePath: profile,
                    title: context.localized.myProfile,
                    icon: Icons.person),
                _accountItem(context,
                    routePath: myPublications,
                    title: context.localized.myPublications,
                    icon: Icons.list),
                _accountItem(context,
                    routePath: myFavorites,
                    title: context.localized.myFavorites,
                    icon: Icons.favorite),
                _accountItem(context,
                    routePath: contentRequest,
                    title: context.localized.contentRequest,
                    icon: Icons.note_alt_sharp),
                _accountItem(context,
                    routePath: knowledgeHubs,
                    title: context.localized.knowledgeHubsPortals,
                    icon: Icons.workspaces),
                Consumer<MainViewModel>(
                  builder: (context, model, child) {
                    return _accountItem(context,
                        routePath: notifications,
                        title: context.localized.notifications,
                        icon: Icons.notifications,
                        isNotification: true,
                        notificationCount:
                            model.state.unreadNotifications.toString());
                  },
                ),
                _accountItem(context,
                    routePath: languageSelection,
                    title: context.localized.changeLanguage,
                    icon: Icons.language),
                _accountItem(context,
                    routePath: '',
                    title: context.localized.faqs,
                    icon: Icons.question_answer, onClick: () {
                  context.pushNamed(webViewer,
                      extra: WebViewerState(
                          linkUrl: EnvConfig.faqsUrl,
                          title: context.localized.faqs));
                }),
                _accountItem(context,
                    routePath: '',
                    title: context.localized.privacyPolicy,
                    icon: Icons.lock, onClick: () {
                  context.pushNamed(webViewer,
                      extra: WebViewerState(
                          linkUrl: EnvConfig.privacyPolicyUrl,
                          title: context.localized.privacyPolicy));
                }),
                ySpacer(20),
                authViewModel.state.isLoggedIn
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: _showLogoutConfirmation, // Updated
                              child: Text(
                                context.localized.logout,
                                style: TextStyle(
                                    color: MainTheme.appColors.red400,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )),
    );
  }

  Widget _accountItem(BuildContext context,
      {required String routePath,
      required String title,
      required IconData icon,
      bool? isNotification,
      String? notificationCount,
      VoidCallback? onClick}) {
    return InkWell(
      onTap: () {
        if (routePath.isNotEmpty) {
          context.pushNamed(routePath);
        } else if (onClick != null) {
          onClick();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    xSpacer(8),
                    Text(title, style: const TextStyle(fontSize: 16))
                  ],
                ),
                (isNotification != null && isNotification == true)
                    ? CircleAvatar(
                        radius: 12,
                        backgroundColor: MainTheme.appColors.red400,
                        child: Text(
                          notificationCount ?? '0',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            ySpacer(16),
            Divider(color: Colors.grey.shade300)
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(
          title: context.localized.loginConfirmationText,
          icon: Icons.logout,
          titleBackgroundColor: MainTheme.appColors.red400,
          content: context.localized.areYouSureYouWantToLogout,
          confirmText: context.localized.logout,
          confirmTextColor: Colors.white,
          confirmBackgroundColor: MainTheme.appColors.red400,
          cancelText: context.localized.cancel,
          onConfirm: () {
            Navigator.of(context).pop(); // Close the dialog
            _logout();
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
    await GoogleSignIn().signOut();
    final loggedOut = await authViewModel.logout();
    // await oauth.logout(); // Sign out from Microsoft

    if (loggedOut) {
      authViewModel.checkLoginStatus();
      // Future.microtask(() => context.go('/$home'));
      if (mounted) {
        RestartWidget.restartApp(context);
      }
    }
  }
}
