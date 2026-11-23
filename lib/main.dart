import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:customer/configs/app_configs.dart';
import 'package:customer/features/wordle/view/wordle_screen.dart';
import 'package:customer/features/wordle/view_model/wordle_view_model.dart';
import 'package:customer/l10n/app_localizations.dart';
import 'package:customer/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/interceptors.dart';
import 'utils/localization.dart';
import 'utils/routes.dart';
import 'utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WordleViewModel(),
        ),
      ],
      builder: (context, child) => ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (context, child) => AdaptiveTheme(
          initial: AdaptiveThemeMode.dark,
          light: appLightTheme,
          dark: appDarkTheme,
          builder: (theme, darkTheme) {
            return MaterialApp(
              navigatorKey: AppConfig.navKey,
              title: 'WORDLE',
              themeMode: context.watch<ThemeProvider>().themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('ja', ''),
              ],
              theme: themedForLocale(
                theme,
                context.watch<LanguageProvider>().locale,
              ),
              darkTheme: themedForLocale(
                darkTheme,
                context.watch<LanguageProvider>().locale,
              ),
              locale: context.watch<LanguageProvider>().locale,
              initialRoute: WordleScreen.routeName,
              onGenerateRoute: onAppGenerateRoute(),
              routes: appRoutes(),
              builder: (context, child) {
                LanguageProvider.initContext(context);
                Localization.init(context);

                if (kDebugMode) {
                  StackTrace.current.toString().log('', true);
                  child = AppStackInterceptorBuilder(child: child!);
                }
                return child!;
              },
            );
          },
        ),
      ),
    );
  }
}
