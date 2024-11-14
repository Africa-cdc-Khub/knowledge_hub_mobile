import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/firebase_options.dart';
import 'package:khub_mobile/providers/locale_provider.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';
import 'package:khub_mobile/services/microsoft_auth_service.dart';
import 'package:khub_mobile/ui/elements/countries/countries_search_view_model.dart';
import 'package:khub_mobile/ui/elements/jobs/jobs_view_model.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';
import 'package:khub_mobile/ui/elements/preferences/preferences_search_view_model.dart';
import 'package:khub_mobile/ui/main_view_model.dart';
import 'package:khub_mobile/ui/screens/account/knowledgehubs/knowledge_hub_view_model.dart';
import 'package:khub_mobile/ui/screens/account/profile/profile_view_model.dart';
import 'package:khub_mobile/ui/screens/ai/ai_view_model.dart';
import 'package:khub_mobile/ui/screens/ai/compare/compare_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/forgotPassword/forgot_password_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/login/login_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/signup/signup_view_model.dart';
import 'package:khub_mobile/ui/screens/communities/communities_view_model.dart';
import 'package:khub_mobile/ui/screens/communities/detail/community_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/content_request/content_request_view_model.dart';
import 'package:khub_mobile/ui/screens/courses/courses_view_model.dart';
import 'package:khub_mobile/ui/screens/events/events_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/create/create_forum_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/detail/forum_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/forums/forums_view_model.dart';
import 'package:khub_mobile/ui/screens/home/categories/categories_view_model.dart';
import 'package:khub_mobile/ui/screens/home/home_view_model.dart';
import 'package:khub_mobile/ui/screens/home/recommended/recommended_publication_view_model.dart';
import 'package:khub_mobile/ui/screens/home/top_searches/top_searches_view_model.dart';
import 'package:khub_mobile/ui/screens/notifications/notifications_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/my_favorites/my_favorites_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/my_publications/my_publications_view_model.dart';
import 'package:khub_mobile/ui/screens/publication/publication_list_view_model.dart';
import 'package:khub_mobile/ui/screens/publish/publish_view_model.dart';
import 'package:khub_mobile/ui/screens/search/search_view_model.dart';
import 'package:khub_mobile/ui/screens/themes/detail/theme_detail_view_model.dart';
import 'package:khub_mobile/ui/screens/themes/theme_view_model.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/utils/navigation/router_config.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'ui/screens/publication/detail/publication_detail_view_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  LOGGER.d("Handling a background message: ${message.messageId}");
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? apple = message.notification?.apple;

  if (notification != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: android != null
            ? AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@drawable/ic_notification',
              )
            : null,
        iOS: apple != null
            ? const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              )
            : null,
      ),
    );
  }
}

late AndroidNotificationChannel channel;

Future<void> setupFlutterNotifications() async {
  channel = const AndroidNotificationChannel(
    'khub_mobile_channel',
    'KHub Mobile Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _initializeFirebaseMessaging() async {
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      LOGGER.d('APNS: $apnsToken');
    }

    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // Register app to general topic
    try {
      await FirebaseMessaging.instance.subscribeToTopic('GENERAL');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError({
        'exception': e,
        'context': context,
        'information': 'Error subscribing to topic',
      }, null);
      LOGGER.e('Error subscribing to topic: $e');
    }

    // Get the token
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      LOGGER.d('Initial FCM Token: $fcmToken');
      await getIt<PreferencesDatasource>()
          .saveString(PreferencesDatasource.fcmTokenKey, fcmToken ?? '');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError({
        'exception': e,
        'context': context,
        'information': 'Error getting FCM token',
      }, null);

      LOGGER.e('Error getting FCM token: $e');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      LOGGER.d('FCM Token refreshed: $fcmToken');
      await getIt<PreferencesDatasource>()
          .saveString(PreferencesDatasource.fcmTokenKey, fcmToken);
    });

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // LOGGER.d('A new message data: ${jsonEncode(message)}');

      if (message.notification != null) {
        // LOGGER.d('Message also contained a notification: ${jsonEncode(message.notification)}');
      }
      showFlutterNotification(message);
    });
  } catch (e) {
    LOGGER.e('Firebase Messaging initialization failed: $e');
    // Continue even if Firebase Messaging fails
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await di.init();

  // Initialize LocaleProvider and wait for language to load
  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.getCachedLanguage();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setupFlutterNotifications();

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    _initializeFirebaseMessaging();
  } catch (e) {
    LOGGER.e(e);
  }

  // Initialize Microsoft Auth Service
  MicrosoftAuthService().initialize(getIt<GlobalKey<NavigatorState>>());

  runApp(RestartWidget(localeProvider: localeProvider));
}

Future<ThemeData> _loadThemeData() async {
  final repository = getIt<ColorThemeRepository>();
  final primaryColor =
      await repository.loadPrimaryColor() ?? const Color(0xff348f41);
  // final secondaryColor =
  // await repository.loadSecondaryColor() ?? const Color(0xff017549);

  return MainTheme.buildTheme(primaryColor);
}

class RestartWidget extends StatefulWidget {
  final LocaleProvider localeProvider;
  const RestartWidget({super.key, required this.localeProvider});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  late Future<ThemeData> _themeDataFuture;

  @override
  void initState() {
    super.initState();
    _themeDataFuture = _loadThemeData();
  }

  void restartApp() {
    setState(() {
      key = UniqueKey();
      _themeDataFuture = _loadThemeData();
      // Reload language when app restarts
      widget.localeProvider.getCachedLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget.localeProvider,
      child: FutureBuilder<ThemeData>(
        future: _themeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(body: Center(child: LoadingView())));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return KeyedSubtree(
              key: key,
              child: MyApp(themeData: snapshot.data!),
            );
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: LoadingView())));
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final ThemeData themeData;

  const MyApp({super.key, required this.themeData});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel(getIt())),
        ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(getIt(), getIt())),
        ChangeNotifierProvider<RecommendedPublicationViewModel>(
            create: (_) =>
                RecommendedPublicationViewModel(getIt(), getIt(), getIt())),
        ChangeNotifierProvider<SearchViewModel>(
            create: (_) => SearchViewModel(getIt(), getIt(), getIt())),
        ChangeNotifierProvider<ThemeViewModel>(
            create: (_) => ThemeViewModel(getIt())),
        ChangeNotifierProvider<ForumsViewModel>(
            create: (_) => ForumsViewModel(getIt(), getIt())),
        ChangeNotifierProvider<ForumDetailViewModel>(
            create: (_) => ForumDetailViewModel(getIt(), getIt())),
        ChangeNotifierProvider<NotificationsViewModel>(
            create: (_) => NotificationsViewModel(getIt())),
        ChangeNotifierProvider<ThemeDetailViewModel>(
            create: (_) => ThemeDetailViewModel(getIt(), getIt())),
        ChangeNotifierProvider<MyPublicationsViewModel>(
            create: (_) => MyPublicationsViewModel(getIt())),
        ChangeNotifierProvider<PublishViewModel>(
            create: (_) => PublishViewModel(
                publicationRepository: getIt(),
                authRepository: getIt(),
                themeRepository: getIt(),
                utilityDatasource: getIt())),
        ChangeNotifierProvider<PublicationListViewModel>(
            create: (_) => PublicationListViewModel(getIt(), getIt())),
        ChangeNotifierProvider<LoginViewModel>(
            create: (_) => LoginViewModel(getIt(), getIt(), getIt())),
        ChangeNotifierProvider<SignupViewModel>(
            create: (_) => SignupViewModel(getIt())),
        ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => ProfileViewModel(getIt())),
        ChangeNotifierProvider<MainViewModel>(
            create: (_) => MainViewModel(getIt(), getIt(), getIt())),
        ChangeNotifierProvider<PublicationDetailViewModel>(
            create: (_) => PublicationDetailViewModel(getIt(), getIt())),
        ChangeNotifierProvider<CreateForumViewModel>(
            create: (_) => CreateForumViewModel(forumRepository: getIt())),
        ChangeNotifierProvider<TopSearchesViewModel>(
            create: (_) => TopSearchesViewModel(getIt(), getIt(), getIt())),
        ChangeNotifierProvider<AiViewModel>(
            create: (_) => AiViewModel(getIt(), getIt())),
        ChangeNotifierProvider<MyFavoritesViewModel>(
            create: (_) => MyFavoritesViewModel(getIt())),
        ChangeNotifierProvider<ContentRequestViewModel>(
            create: (_) =>
                ContentRequestViewModel(publicationRepository: getIt())),
        ChangeNotifierProvider<CommunitiesViewModel>(
            create: (_) => CommunitiesViewModel(
                communitiesRepository: getIt(),
                authRepository: getIt(),
                connectionRepository: getIt())),
        ChangeNotifierProvider<CommunityDetailViewModel>(
            create: (_) => CommunityDetailViewModel(getIt(), getIt())),
        ChangeNotifierProvider<EventsViewModel>(
            create: (_) => EventsViewModel(
                eventRepository: getIt(),
                eventsDatasource: getIt(),
                connectionRepository: getIt())),
        ChangeNotifierProvider<KnowledgeHubViewModel>(
            create: (_) => KnowledgeHubViewModel(
                utilityDatasource: getIt(),
                preferencesDatasource: getIt(),
                authRepository: getIt())),
        ChangeNotifierProvider<CompareViewModel>(
            create: (_) => CompareViewModel(getIt())),
        ChangeNotifierProvider<CategoriesViewModel>(
            create: (_) => CategoriesViewModel(getIt(), getIt())),
        ChangeNotifierProvider<CoursesViewModel>(
            create: (_) => CoursesViewModel(getIt())),
        ChangeNotifierProvider<ForgotPasswordViewModel>(
            create: (_) => ForgotPasswordViewModel(getIt())),
        ChangeNotifierProvider<JobsViewModel>(
            create: (_) => JobsViewModel(utilityDatasource: getIt())),
        ChangeNotifierProvider<CountriesSearchViewModel>(
            create: (_) =>
                CountriesSearchViewModel(utilityDatasource: getIt())),
        ChangeNotifierProvider<PreferencesSearchViewModel>(
            create: (_) =>
                PreferencesSearchViewModel(utilityDatasource: getIt())),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'KHub',
          locale: localeProvider.locale,
          theme: themeData, // MainTheme.defaultTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRouter().mainRouter,
        ),
      ),
    );
  }
}
