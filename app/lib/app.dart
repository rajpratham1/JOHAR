import 'package:flutter/material.dart';
import 'package:johar/l10n/app_localizations.dart';
import 'core/theme.dart';
import 'core/services/local_store.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

class JoharApp extends StatelessWidget {
  const JoharApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app when the chosen language changes.
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocalStore.locale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'JOHAR',
          debugShowCheckedModeBanner: false,
          theme: joharTheme(),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LocalStore.workerName == null ? const LoginScreen() : const HomeScreen(),
        );
      },
    );
  }
}
