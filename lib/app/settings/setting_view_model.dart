import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsViewModelProvider = Provider((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  return SettingViewModel(settings: settings, ref: ref);
});

final settingsProvider = Provider.autoDispose<Settings>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  return settings;
});

class SettingViewModel extends StateNotifier<Settings> {
  final Settings settings;
  final ProviderRef ref;
  SettingViewModel({required this.settings, required this.ref})
      : super(Settings(serverIp: "", serverPort: "")) {
    // getSettings();
  }

  // void getSettings() {
  //   state = sharedPreferencesService.getSettings();
  // }

  setSettings(ip, port) {
    ref.read(sharedPreferencesServiceProvider.notifier).setSettings(ip, port);
    // ref.refresh(settingsProvider);
    // ref.refresh(deckCommandProvider);
    // state = Settings(serverIp: ip, serverPort: port);
  }

  deleteSetting() {
    ref.read(sharedPreferencesServiceProvider.notifier).deleteSettings();
    // ref.refresh(settingsProvider);
  }
}
