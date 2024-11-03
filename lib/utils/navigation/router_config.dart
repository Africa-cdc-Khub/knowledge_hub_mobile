import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khub_mobile/models/course_model.dart';
import 'package:khub_mobile/models/event_model.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/ui/screens/account/account_screen.dart';
import 'package:khub_mobile/ui/screens/account/knowledgehubs/knowledge_hubs_screen.dart';
import 'package:khub_mobile/ui/screens/account/language_selection_screen.dart';
import 'package:khub_mobile/ui/screens/account/profile/profile_screen.dart';
import 'package:khub_mobile/ui/screens/ai/compare/compare_screen.dart';
import 'package:khub_mobile/ui/screens/auth/forgotPassword/forgot_password_screen.dart';
import 'package:khub_mobile/ui/screens/auth/login/login_screen.dart';
import 'package:khub_mobile/ui/screens/auth/signup/signup_screen.dart';
import 'package:khub_mobile/ui/screens/communities/communities_screen.dart';
import 'package:khub_mobile/ui/screens/communities/detail/community_detail_screen.dart';
import 'package:khub_mobile/ui/screens/content_request/content_request_screen.dart';
import 'package:khub_mobile/ui/screens/courses/course_detail.dart';
import 'package:khub_mobile/ui/screens/courses/courses_screen.dart';
import 'package:khub_mobile/ui/screens/events/event_detail_screen.dart';
import 'package:khub_mobile/ui/screens/forums/create/create_forum_screen.dart';
import 'package:khub_mobile/ui/screens/forums/detail/forum_detail_screen.dart';
import 'package:khub_mobile/ui/screens/forums/forums_screen.dart';
import 'package:khub_mobile/ui/screens/forums/forums_view_model.dart';
import 'package:khub_mobile/ui/screens/home/home_screen.dart';
import 'package:khub_mobile/ui/screens/main/main_scaffold.dart';
import 'package:khub_mobile/ui/screens/notifications/notifications_screen.dart';
import 'package:khub_mobile/ui/screens/onboarding/splash_screen.dart';
import 'package:khub_mobile/ui/screens/publication/my_favorites/my_favorites_screen.dart';
import 'package:khub_mobile/ui/screens/publication/my_publications/my_publications_screen.dart';
import 'package:khub_mobile/ui/screens/publication/detail/publication_detail_screen.dart';
import 'package:khub_mobile/ui/screens/publication/publications_list_screen.dart';
import 'package:khub_mobile/ui/screens/publication/viewer/publication_pdf_viewer.dart';
import 'package:khub_mobile/ui/screens/publication/viewer/web_viewer.dart';
import 'package:khub_mobile/ui/screens/publish/create_publication_screen.dart';
import 'package:khub_mobile/ui/screens/search/search_screen.dart';
import 'package:khub_mobile/ui/screens/success/success_screen.dart';
import 'package:khub_mobile/ui/screens/themes/detail/theme_detail_screen.dart';
import 'package:khub_mobile/utils/navigation/go_route_observer.dart';
import 'package:khub_mobile/utils/navigation/route_names.dart';
import 'package:provider/provider.dart';

class AppRouter {
  // final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // final GlobalKey<NavigatorState> _sectionANavigatorKey =
  //     GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

  final GoRouter _mainRouter = GoRouter(
      initialLocation: "/$home",
      redirect: (ctx, state) {
        return null;
      },
      observers: [
        GoRouteObserver(
          onForumsRefresh: (BuildContext context) {
            // Trigger a rebuild of the ForumsScreen
            // You might need to use a global key or a state management solution here
            // For example, if using Provider:
            Provider.of<ForumsViewModel>(context, listen: false).fetchForums();
          },
        ),
      ],
      routes: [
        GoRoute(
          // Splash
          name: splashScreen,
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SplashScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // SEARCH
        GoRoute(
          name: search,
          path: '/$search',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: SearchScreen(searchState: state.extra as SearchScreenState),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // COMMUNITY DETAIL
        GoRoute(
          name: communityDetail,
          path: '/$communityDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: CommunityDetailScreen(
                model: state.extra as CommunityDetailModel),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // EVENT DETAIL
        GoRoute(
          name: eventDetail,
          path: '/$eventDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: EventDetailScreen(event: state.extra as EventModel),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // AI Compare Publications
        GoRoute(
          name: aiComparePublications,
          path: '/$aiComparePublications',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const CompareScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // KNOWLEDGE HUBS
        GoRoute(
          name: knowledgeHubs,
          path: '/$knowledgeHubs',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const KnowledgeHubsScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // CREATE FORUM
        GoRoute(
          name: createForum,
          path: '/$createForum',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const CreateForumScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // MY PUBLICATIONS
        GoRoute(
          name: myPublications,
          path: '/$myPublications',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const MyPublicationsScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // MY FAVORITES
        GoRoute(
          name: myFavorites,
          path: '/$myFavorites',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const MyFavoritesScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // PUBLICATION LIST
        GoRoute(
          name: publicationList,
          path: '/$publicationList',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: PublicationsListScreen(
                state: state.extra as PublicationListScreenState),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // PUBLICATION VIEWER
        GoRoute(
          name: publicationPdfViewer,
          path: '/$publicationPdfViewer',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: PublicationPdfViewer(pdfUrl: state.extra as String),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // WEB VIEWER
        GoRoute(
          name: webViewer,
          path: '/$webViewer',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: WebViewer(state: state.extra as WebViewerState),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // NOTIFICATIONS
        GoRoute(
          name: notifications,
          path: '/$notifications',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const NotificationsScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // CONTENT REQUEST
        GoRoute(
          name: contentRequest,
          path: '/$contentRequest',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const ContentRequestScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // PROFILE
        GoRoute(
            name: profile,
            path: '/$profile',
            pageBuilder: (context, state) => CustomTransitionPage(
                  child: const ProfileScreen(),
                  transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) =>
                      FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
            routes: [
              GoRoute(
                  path: login,
                  builder: (context, state) => const LoginScreen()),
            ]),

        // FORUM DETAIL
        GoRoute(
          name: forumDetail,
          path: '/$forumDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const ForumDetailScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // PUBLICATION
        GoRoute(
          name: publish,
          path: "/$publish",
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const CreatePublicationScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // PUBLICATION DETAIL
        GoRoute(
          name: publicationDetail,
          path: '/$publicationDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const PublicationDetailScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // COURSE DETAIL
        GoRoute(
          name: courseDetail,
          path: '/$courseDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: CourseDetailScreen(course: state.extra as CourseModel),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // THEME DETAIL
        GoRoute(
          name: themeDetail,
          path: '/$themeDetail',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: ThemeDetailScreen(theme: state.extra as ThemeModel),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        /*************   AUTH SCREENS ************/
        // LOGIN
        GoRoute(
          name: login,
          path: '/$login',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const LoginScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // REGISTER
        GoRoute(
          name: signUp,
          path: '/$signUp',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SignUpScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // FORGOT PASSWORD
        GoRoute(
          name: forgotPassword,
          path: '/$forgotPassword',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const ForgotPasswordScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // LANGUAGE
        GoRoute(
          name: languageSelection,
          path: '/$languageSelection',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const LanguageSelectionScreen(),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        // SUCCESS
        GoRoute(
          name: success,
          path: '/$success',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: SuccessScreen(successState: state.extra as SuccessState),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),

        //BOTTOMBAR SCREENS
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: home,
                  path: "/$home",
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const HomeScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: forums,
                  path: "/$forums",
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const ForumsScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: communities,
                  path: "/$communities",
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const CommunitiesScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: learning,
                  path: "/$learning",
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const CoursesScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: account,
                  path: "/$account",
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const AccountScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]);

  GoRouter get mainRouter => _mainRouter;
}
