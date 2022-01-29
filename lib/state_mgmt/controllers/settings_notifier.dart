import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/state_mgmt/models/settings_model.dart';
import 'package:water_jug_riddle/state_mgmt/repositories/settings_repository.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsRepository _settingsRepository;
  SettingsModel? settingsModel;
  String? platform;

  SettingsNotifier(this._settingsRepository)
      : super(const SettingsStateInitial());

  setSettingsAndNotify(Map<String, dynamic> newSettingsMap) async {
    var newSettingsModel = SettingsModel.fromMap(newSettingsMap);

    if (mounted) {
      state = SettingsStateChanged(newSettingsModel);
    }

    debugPrint("SettingsNotifier getSettingsAndNotify, state: $state");
  }
}

enum SettingsStatus { initial, changed, error }

abstract class SettingsState {
  const SettingsState();

  SettingsModel? get settingsModel => null;
}

class SettingsStateInitial extends SettingsState {
  const SettingsStateInitial();
}

class SettingsStateChanged extends SettingsState {
  @override
  final SettingsModel settingsModel;

  const SettingsStateChanged(this.settingsModel);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateChanged &&
        other.settingsModel == settingsModel;
  }

  @override
  int get hashCode => settingsModel.hashCode;
}