import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:water_jug_riddle/state_mgmt/models/settings_model.dart';

abstract class SettingsRepository {
  Future<SettingsModel> fetchSettings();
}

class PublicSettingsRepository implements SettingsRepository {
  late SettingsModel settingsModelFromString;

  @override
  Future<SettingsModel> fetchSettings() async {
    debugPrint("PublicSettingsControllerRepository fetchSettingsController");

    String platform = kIsWeb
        ? "web"
        : Platform.isAndroid
            ? 'android'
            : 'ios';

    settingsModelFromString = SettingsModel.fromMap(Map.of({
      'language': ("en"),
      'settings': const Locale("en"),
      'platform': platform
    }));

    debugPrint(
        "PublicSettingsControllerRepository fetchSettingsController return "
        "SettingsModel.fromString: ${settingsModelFromString.language}");

    return settingsModelFromString;
  }
}