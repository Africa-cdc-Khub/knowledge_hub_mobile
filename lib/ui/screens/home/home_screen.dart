import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/ui/elements/labels.dart';
import 'package:khub_mobile/ui/elements/not_logged_in_banner.dart';
import 'package:khub_mobile/ui/elements/notification_icon_with_count.dart';
import 'package:khub_mobile/ui/elements/search_bar.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/models/search_type_enum.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/account/profile/profile_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/events/events_list.dart';
import 'package:khub_mobile/ui/screens/events/events_view_model.dart';
import 'package:khub_mobile/ui/screens/home/categories/categories_screen.dart';
import 'package:khub_mobile/ui/screens/home/recommended/recommended_publications.dart';
import 'package:khub_mobile/ui/screens/home/top_searches/top_searches.dart';
import 'package:khub_mobile/ui/screens/publication/publications_list_screen.dart';
import 'package:khub_mobile/ui/screens/themes/theme_list.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/screens/themes/theme_view_model.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MainViewModel mainViewModel;
  late AuthViewModel authViewModel;
  late ThemeViewModel themeViewModel;
  late EventsViewModel eventsViewModel;

  @override
  void initState() {
    mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    themeViewModel = Provider.of<ThemeViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final shortestSide = screenSize.shortestSide;
      final isTablet = shortestSide >= 600;
      _getThemes(isTablet);
    });

    authViewModel.checkLoginStatus();
    _getAppSettings();
    _getUtilities();
    _getCurrentUser();
    _getUnreadNotificationCount();
    super.initState();
  }

  Future<void> _getAppSettings() async {
    await mainViewModel.fetchAppSettings();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getThemes(bool isTablet) async {
    await themeViewModel.fetchThemes(isTablet);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getUtilities() async {
    await mainViewModel.syncUtilities();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getCurrentUser() async {
    await authViewModel.getCurrentUser();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getUnreadNotificationCount() async {
    await mainViewModel.getUnreadNotificationCount();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // Material Design tablet breakpoint

    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
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
        height: double.infinity,
        padding: const EdgeInsets.all(0.0),
        color: MainTheme.appColors.white300,
        child: ListView(
          children: [
            const AppSearchBar(searchType: SearchType.publication),
            ySpacer(4.0),
            Container(
                constraints: const BoxConstraints(
                    minHeight: 10, minWidth: double.infinity, maxHeight: 240),
                child: const EventsList()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: homeLabel(
                context,
                title: context.localized.themes,
                description: context.localized.selectAPublicHealthTheme,
              ),
            ),
            ySpacer(14),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                constraints: BoxConstraints(
                    minHeight: 50,
                    minWidth: double.infinity,
                    maxHeight: isTablet ? 160 : 110),
                child: const ThemeList()),
            ySpacer(16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: homeLabel(context,
                  title: context.localized.recommended,
                  actionLabel: context.localized.viewAll, onClick: () {
                context.pushNamed(publicationList,
                    extra: PublicationListScreenState(
                        listType: 1, title: context.localized.recommended));
              }),
            ),
            ySpacer(6.0),
            Container(
                padding: const EdgeInsets.only(left: 10.0),
                constraints: const BoxConstraints(
                    minHeight: 100, minWidth: double.infinity, maxHeight: 300),
                child: const RecommendedPublications()),
            ySpacer(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: homeLabel(context,
                  title: context.localized.resourceCategories),
            ),
            ySpacer(6.0),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 16),
              child: Container(
                  constraints: const BoxConstraints(
                      minHeight: 40, minWidth: 50, maxHeight: 80),
                  child: const CategoriesScreen()),
            ),
            Consumer<AuthViewModel>(builder: (context, provider, child) {
              return provider.state.isLoggedIn
                  ? const SizedBox.shrink()
                  : const NotLoggedInBanner();
            }),
            Padding(
                padding:
                    const EdgeInsets.only(left: 14.0, right: 14.0, top: 16),
                child: homeLabel(context,
                    title: context.localized.topSearches,
                    actionLabel: context.localized.viewAll, onClick: () {
                  context.pushNamed(publicationList,
                      extra: PublicationListScreenState(
                          listType: 2, title: context.localized.topSearches));
                })),
            ySpacer(6.0),
            Container(
                padding: const EdgeInsets.only(left: 10.0),
                constraints: const BoxConstraints(
                    minHeight: 100, minWidth: double.infinity, maxHeight: 300),
                child: const TopSearches()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    const logoWidth = 100.0;
    const logoHeight = 50.0;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Consumer<AuthViewModel>(builder: (context, provider, child) {
        return provider.state.currentUser?.settings != null
            ? Image.network(
                provider.state.currentUser?.settings?.logo ?? '',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Image.asset('assets/africa_cdc.jpg',
                        height: logoHeight,
                        width: logoWidth,
                        fit: BoxFit.cover);
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Display a placeholder image when the remote image fails to load
                  return Image.asset('assets/africa_cdc.jpg',
                      height: logoHeight, width: logoWidth, fit: BoxFit.cover);
                },
              )
            : Image.asset(
                'assets/africa_cdc.jpg',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.cover,
              );
      }),
      actions: [
        Consumer<AuthViewModel>(builder: (context, provider, child) {
          final userImage = provider.state.currentUser?.photo ?? '';

          return InkWell(
            onTap: () {
              Provider.of<ProfileViewModel>(context, listen: false)
                  .getCurrentUser();
              context.pushNamed(profile);
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: ClipOval(
                  child: userImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: userImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SizedBox(
                            height: 5,
                            width: 5,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/default_user.jpg'),
                        )
                      : Image.asset('assets/images/default_user.jpg')),
            ),
          );
        }),
        xSpacer(6),
        Consumer<MainViewModel>(
          builder: (context, provider, child) {
            return InkWell(
                onTap: () {
                  context.pushNamed(notifications);
                },
                child: NotificationIconCount(
                    size: 30,
                    icon: Icons.notifications,
                    notificationCount: provider.state.unreadNotifications));
          },
        ),
        xSpacer(10)
      ],
    );
  }
}
