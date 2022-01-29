import 'dart:ui';

import 'package:water_jug_riddle/helper/enums.dart';

class SettingsModel {
  SupportedPlatformsEnum platform = SupportedPlatformsEnum.web;
  final String language;
  final Locale locale;

  SettingsModel({
    required this.platform,
    required this.language,
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsModel &&
        other.language == language &&
        other.platform == platform &&
        other.locale == locale;
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      platform: map['platform'] ?? SupportedPlatformsEnum.web,
      language: map['language'] ?? 'en',
      locale: map['locale'] ?? const Locale('en'),
    );
  }

  @override
  int get hashCode => language.hashCode ^ locale.hashCode;
}