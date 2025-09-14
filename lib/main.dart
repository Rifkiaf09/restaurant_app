import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'services/background_service.dart';
import 'services/notification_service.dart';

import 'core/api/restaurant_api.dart';
import 'core/db/database_helper.dart';

import 'providers/restaurant_list_provider.dart';
import 'providers/restaurant_detail_provider.dart';
import 'providers/restaurant_search_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/settings_provider.dart';

import 'ui/pages/restaurant_detail_page.dart';
import 'ui/pages/restaurant_list_page.dart';
import 'ui/pages/restaurant_search_page.dart';
import 'ui/pages/favorites_page.dart';
import 'ui/pages/settings_page.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Request permission untuk notifikasi (Android 13+ dan iOS/macOS)
Future<void> requestNotificationPermission() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android 13+ (Tiramisu) runtime permission
  final androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.requestNotificationsPermission();

  // iOS / macOS
  final iosImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
  await iosImplementation?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize local notifications and workmanager
  await NotificationService.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // request izin notifikasi sebelum runApp
  await requestNotificationPermission();

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorSeed = Color(0xFF3E7BFA);

    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorSeed,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      useMaterial3: true,
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorSeed,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );

    final api = RestaurantApi();
    final dbHelper = DatabaseHelper();

    return MultiProvider(
      providers: [
        Provider<RestaurantApi>.value(value: api),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(dbHelper: dbHelper),
        ),
        ChangeNotifierProvider(create: (_) => RestaurantListProvider(api: api)),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(api: api),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Restaurant App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProv.mode,
            initialRoute: RestaurantListPage.routeName,
            routes: {
              RestaurantListPage.routeName: (_) => const RestaurantListPage(),
              RestaurantSearchPage.routeName: (_) =>
                  const RestaurantSearchPage(),
              FavoritesPage.routeName: (_) => const FavoritesPage(),
              SettingsPage.routeName: (_) => const SettingsPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == RestaurantDetailPage.routeName) {
                final id = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<RestaurantDetailProvider>(
                    create: (_) =>
                        RestaurantDetailProvider(api: api)..fetchDetail(id),
                    child: RestaurantDetailPage(id: id),
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
