import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/state_mgmt/controllers/settings_notifier.dart';
import 'package:water_jug_riddle/state_mgmt/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => PublicSettingsRepository(),
);

final settingsNotifierProvider =
    StateNotifierProvider.autoDispose<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(ref.watch(settingsRepositoryProvider)),
);