import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setupViewModelProvider = Provider((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return SetupViewModel(sharedPreferencesService, ref);
});

// final setupProvider = StateNotifierProvider<SetupViewModel, Settings>((ref) {
//   final settings = ref.watch(settingsDataProvider);
//   return settings;
// });

class SetupViewModel extends StateNotifier<Settings> {
  final Settings settings;
  final Ref ref;
  SetupViewModel(this.settings, this.ref)
      : super(Settings(serverIp: "", serverPort: ""));

  void setSettings(ip, port) {
    ref.read(sharedPreferencesServiceProvider.notifier).setSettings(ip, port);
    state = Settings(serverIp: ip, serverPort: port);
  }
}
