// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_interactive_keyboard/flutter_interactive_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Project imports:
import 'package:cheon/flavor_config.dart';
import 'package:cheon/pages/home/home_page.dart';
import 'package:cheon/routes.dart';
import 'package:cheon/view_models/app_info_view_model.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:cheon/view_models/lessons_view_model.dart';
import 'package:cheon/view_models/preferences_view_model.dart';
import 'package:cheon/view_models/revision_view_model.dart';
import 'package:cheon/view_models/study_view_model.dart';
import 'package:cheon/view_models/subjects_view_model.dart';
import 'package:cheon/view_models/teachers_view_model.dart';
import 'package:cheon/view_models/timeline_view_model.dart';
import 'package:cheon/view_models/timetable_view_model.dart';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
// import 'package:wiredash/wiredash.dart';

/// Handles app theming and initialisation
void configureApp() {
  /// UI development can be done without a physical device by running the
  /// following code provided by:
  /// https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.fuchsia;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }

  WidgetsFlutterBinding.ensureInitialized();
}

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  static const double borderRadius = 8;

  /// Dark theme colours based on
  /// https://material.io/design/color/dark-theme.html
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF212121);
  static const Color darkBottomBar = Color(0xFF303030);

  static const Color amoledBackground = Colors.black;
  static const Color amoledSurface = Color(0xFF121212);
  static const Color amoledBottomBar = darkSurface;

  static Color lightBackground = Colors.grey.shade50;
  static const Color lightSurface = Colors.white;
  static const Color lightBottomBar = Color(0xFFFAFAFA);

  @visibleForTesting
  static const MaterialColor accentColor = Colors.green;

  /// Transitions used by the Flutter framework to animate page switching.
  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    },
  );

  /// A global [FirebaseAnalytics] instance for event logging
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// The themeing used for the app.
  @visibleForTesting
  static ThemeData theme({@required bool isDark, bool isAmoled = false}) {
    final Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    final Color borderColor =
        isDark ? const Color(0x1FFFFFFF) : const Color(0x2F000000);
    final Color dividerColor =
        isDark ? const Color(0x1FFFFFFF) : Colors.grey.shade500;
    final Color background = isDark
        ? (isAmoled ? amoledBackground : darkBackground)
        : lightBackground;
    final Color surface =
        isDark ? (isAmoled ? amoledSurface : darkSurface) : lightSurface;
    final Color onSurface = isDark ? Colors.white : Colors.grey.shade800;
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: brightness,
      backgroundColor: background,
      scaffoldBackgroundColor: background,
      // Primary color for framework components
      primaryColor: accentColor,
      primaryColorLight: const Color(0xFF80e27e),
      primaryColorDark: const Color(0xFF087f23),
      primaryColorBrightness: brightness,
      primarySwatch: accentColor,
      // Secondary accent colour
      accentColor: accentColor,
      accentColorBrightness: Brightness.dark,
      // Color Scheme for all other components
      colorScheme: ColorScheme(
        primary: accentColor,
        primaryVariant: const Color(0xFF087f23),
        onPrimary: Colors.white,
        secondary: const Color(0xFF2bbd7e),
        secondaryVariant: const Color(0xFF008c51),
        onSecondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        background: background,
        onBackground: isDark ? const Color(0xFFf8f8f8) : Colors.grey.shade800,
        error: const Color(0xFFB00020),
        onError: Colors.white,
        brightness: brightness,
      ),
      // Miscellaneous properties
      splashColor: Colors.transparent,
      textSelectionHandleColor: accentColor,
      toggleableActiveColor: accentColor,
      dividerColor: dividerColor,
      bottomAppBarColor:
          isDark ? isAmoled ? amoledBottomBar : darkBottomBar : lightBottomBar,
      buttonColor: isDark ? const Color(0xFF303030) : const Color(0xFFE4E6EB),
      buttonTheme: ButtonThemeData(
        buttonColor: isDark ? accentColor : Colors.grey.shade300,
      ),
      canvasColor: background,
      // Material design component theming
      buttonBarTheme: const ButtonBarThemeData(
        buttonTextTheme: ButtonTextTheme.accent,
      ),
      appBarTheme: AppBarTheme(
        color: background,
        brightness: brightness,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actionsIconTheme: IconThemeData(color: onSurface),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      snackBarTheme:
          const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogBackgroundColor: surface,
      pageTransitionsTheme: _pageTransitionsTheme,
      textTheme: const TextTheme(
        headline5: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        subtitle1: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(App.borderRadius),
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        textTheme: const CupertinoTextThemeData(),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: onSurface,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: onSurface,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),

      iconTheme: IconThemeData(color: onSurface),

      // platform: TargetPlatform.iOS,
    );
  }

  /// Configures the theming of the status bar where notifications are shown.
  void setStatusBarTheme({
    @required BuildContext context,
    @required ThemeMode themeMode,
    bool isAmoled = false,
  }) {
    bool isDark;
    switch (themeMode) {
      case ThemeMode.light:
        isDark = false;
        break;
      case ThemeMode.dark:
        isDark = true;
        break;
      case ThemeMode.system:
        isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        break;
    }
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor:
              isAmoled ? App.amoledBottomBar : App.darkBottomBar,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: App.lightBottomBar,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  /// The [ListTile] UI component does not support the standart theme system so
  /// it must be set via this function.
  Widget setListTileTheme({@required Widget child, @required bool isDark}) {
    return ListTileTheme(
      child: child,
      iconColor: isDark ? Colors.white : Colors.grey.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Providers offer widget level dependency injection with O(1) access time
    // to objects in the widget tree.
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<Preferences>(create: (_) => Preferences()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final Preferences preferences = context.watch<Preferences>();
          final ThemeMode themeMode = preferences.themeMode;
          final bool isAmoled = preferences.amoledDark;
          final String titlePrefix = !FlavorConfig.instance.isProduction()
              ? FlavorConfig.instance.name
              : '';
          /* projectId: Platform.environment['wiredash_project_id'],
            secret: Platform.environment['wiredash_secret'],
            navigatorKey: _navigatorKey,
            theme: WiredashThemeData(
              primaryColor: Colors.green,
              secondaryColor: const Color(0xFF2bbd7e),
            ), */
          return MaterialApp(
            title: '$titlePrefix Cheon Smart Planner'.trimLeft(),
            theme: theme(isDark: false),
            darkTheme: theme(isDark: true, isAmoled: isAmoled),
            themeMode: themeMode,
            color: Colors.green,
            home: const HomePage(),
            routes: routes,
            showPerformanceOverlay: FlavorConfig.instance.isProfile(),
            navigatorObservers: <NavigatorObserver>[
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            navigatorKey: _navigatorKey,
            builder: (BuildContext context, Widget child) {
              if (FlavorConfig.instance.isProduction() == false) {
                // Adds a banner to the top left of the screen to show that the
                // app is running in development/staging mode
                child = Banner(
                  location: BannerLocation.topStart,
                  message: FlavorConfig.instance.name,
                  color: FlavorConfig.instance.color,
                  child: child,
                );
              }

              setStatusBarTheme(
                context: context,
                themeMode: themeMode,
                isAmoled: isAmoled,
              );

              child = setListTileTheme(
                isDark: Theme.of(context).brightness == Brightness.dark,
                child: child,
              );

              if (Theme.of(context).platform == TargetPlatform.iOS) {
                // Closes the keyboard when swiping down
                // Android users have a back button
                child = KeyboardManagerWidget(
                  child: child,
                  onKeyboardOpen: () {},
                  onKeyboardClose: () {},
                );
              }

              /// More O(1) objects injected into the widget tree.
              /// The [MultiProvider] widget allows these to be given in a list
              /// instead of by nesting the widgets.
              child = MultiProvider(
                child: child,
                providers: <SingleChildWidget>[
                  ChangeNotifierProvider<AppInfo>(create: (_) => AppInfo()),
                  Provider<SubjectsVM>(
                    create: (_) => SubjectsVM(),
                    dispose: (_, SubjectsVM vm) => vm.dispose(),
                  ),
                  Provider<TeachersVM>(
                    create: (_) => TeachersVM(),
                    dispose: (_, TeachersVM vm) => vm.dispose(),
                  ),
                  Provider<LessonsVM>(
                    create: (_) => LessonsVM(),
                    dispose: (_, LessonsVM vm) => vm.dispose(),
                  ),
                  ChangeNotifierProvider<RevisionVM>(
                    create: (_) => RevisionVM(),
                  ),
                  ChangeNotifierProvider<TimelineVM>(
                    create: (_) => TimelineVM(),
                  ),
                  Provider<ExamsVM>(
                    create: (_) => ExamsVM(),
                    dispose: (_, ExamsVM vm) => vm.dispose(),
                  ),
                  ChangeNotifierProvider<TimetableVM>(
                    create: (_) => TimetableVM(),
                  ),
                  Provider<StudyVM>(
                    create: (_) => StudyVM(),
                    dispose: (_, StudyVM vm) => vm.dispose(),
                  ),
                ],
              );

              return child;
            },
          );
        },
      ),
    );
  }
}
