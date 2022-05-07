import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webSocketServiceProvider = StateNotifierProvider(((ref) {
  final Settings settings = ref.watch(sharedPreferencesServiceProvider);
  return WebSocketService(settings: settings, ref: ref);
}));

class WebSocketService extends StateNotifier<Settings> {
  Settings? settings;
  final Ref ref;
  WebSocketService({required this.settings, required this.ref})
      : super(settings ?? Settings(serverIp: '', serverPort: ''));
}
