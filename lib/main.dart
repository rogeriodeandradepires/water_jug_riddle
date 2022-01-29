import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:water_jug_riddle/modular/app_module.dart';
import 'package:water_jug_riddle/modular/routes/routes.dart';
import 'package:water_jug_riddle/state_mgmt/models/settings_model.dart';
import 'package:water_jug_riddle/state_mgmt/providers/settings_providers.dart';
import 'package:water_jug_riddle/ui/pages_keys/general_keys.dart';

import 'helper/enums.dart';

void main() {
  if (kIsWeb) {
    try {
      setPathUrlStrategy();
    } catch (e, s) {
      //debugPrint('setPathUrlStrategy: $e');
    }
  }

  runApp(ModularApp(
    module: AppModule(),
    child: ProviderScope(
      child: MainApp(
        key: ValueKey(ApplicationKeys.mainKey()),
      ),
    ),
  ));
}

class MainApp extends ConsumerWidget {
  static GlobalKey mainAppKey = GlobalKey();

  const MainApp({required ValueKey key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _settings =
        ref.watch(settingsNotifierProvider.notifier.select((state) {
      return state.settingsModel ??
          SettingsModel.fromMap(Map.of({
            'language': "en",
            'locale': const Locale("en"),
            'platform': kIsWeb
                ? SupportedPlatformsEnum.web
                : (Platform.isIOS
                    ? SupportedPlatformsEnum.ios
                    : SupportedPlatformsEnum.android)
          }));
    }));

    return _settings.platform == SupportedPlatformsEnum.ios
        ? CupertinoApp(
            key: mainAppKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', ''),
              Locale('pt', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              return _settings.locale;
            },
            locale: _settings.locale,
            initialRoute: RoutePaths.start(),
          ).modular()
        : MaterialApp(
            key: mainAppKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', ''),
              Locale('pt', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              return _settings.locale;
            },
            locale: _settings.locale,
            initialRoute: RoutePaths.start(),
          ).modular();
  }
}